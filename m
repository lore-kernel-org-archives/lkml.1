Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYFFOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYFFOtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbYFFOtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:49:00 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:48041 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYFFOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:48:58 -0400
Message-ID: <48494E55.3080704@mandriva.org>
Date: Fri, 06 Jun 2008 17:48:53 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Tomas Winkler <tomasw@gmail.com>, Ian Schram <ischram@telenet.be>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
References: <4848289D.1080205@mandriva.org>	 <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com>	 <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org>	 <48485F12.2050908@mandriva.org> <48488878.5040708@telenet.be>	 <1ba2fa240806060432t73ecb318x89e877241aa6ef55@mail.gmail.com>	 <48492734.9080901@mandriva.org> <48492E85.6010307@mandriva.org>	 <1ba2fa240806060659wf4e4088s8afdd2f7f854ea09@mail.gmail.com> <1212762569.28631.6.camel@localhost.localdomain>
In-Reply-To: <1212762569.28631.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams skrev:
> On Fri, 2008-06-06 at 16:59 +0300, Tomas Winkler wrote:
>> On Fri, Jun 6, 2008 at 3:33 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>>> Thomas Backlund skrev:
>>>> Tomas Winkler skrev:
>>>>> On Fri, Jun 6, 2008 at 3:44 AM, Ian Schram <ischram@telenet.be> wrote:
>>>>>> Isn't this the Oops Joonwoo Park wanted to patch with
>>>>>>
>>>>>> "[PATCH] iwlwifi: fix oops on wep key insertion" 27/5/2008
>>>>>>
>>>>>> invalid length of webkey that would/should be handled in mac80211?
>>>>>>
>>>>>> ian
>>>>> Yes, it looks like.
>>>> Ummm, what has a wep key to do with me trying to access a WPA2-Personal
>>>> encrypted net ?
>> Not sure yet, but mac is trying to assign default/static wep key.
> 
> The output of wpa_supplicant with "-dddt" would be quite useful in
> figuring this out.
> 
> The supplicant does always _clear_ static WEP keys when it starts the
> interface, when a connection drops, and when it quits.  Maybe that's
> where it's coming from?  But it should just be setting the "disabled"
> bit in the WEXT structure and sending a key of all zeros.
> 
> Dan
> 


Here you go:

> [root@5720g /]# wpa_supplicant -dddt -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
> 1212763146.040022: Initializing interface 'wlan0' conf '/etc/wpa_supplicant.conf' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
> 1212763146.040145: Configuration file '/etc/wpa_supplicant.conf' -> '/etc/wpa_supplicant.conf'
> 1212763146.040159: Reading configuration file '/etc/wpa_supplicant.conf'
> 1212763146.040211: ctrl_interface='/var/run/wpa_supplicant'
> 1212763146.040235: eapol_version=1
> 1212763146.040245: ap_scan=1
> 1212763146.040253: fast_reauth=1
> 1212763146.040261: Line: 10 - start of a new named blob 'exampleblob'
> 1212763146.040287: Line: 14 - start of a new network block
> 1212763146.040305: PSK (ASCII passphrase) - hexdump_ascii(len=25): [REMOVED]
> 1212763146.040318: scan_ssid=1 (0x1)
> 1212763146.040331: ssid - hexdump_ascii(len=5):
>      64 6c 69 6e 6b                                    dlink
> 1212763146.066118: PSK (from passphrase) - hexdump(len=32): [REMOVED]
> 1212763146.066180: Priority group 0
> 1212763146.066192:    id=0 ssid='dlink'
> 1212763146.066201: Initializing interface (2) 'wlan0'
> 1212763146.093827: Interface wlan0 set UP - waiting a second for the driver to complete initialization
> 1212763147.094230: SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
> 1212763147.094254:   capabilities: key_mgmt 0xf enc 0xf
> 1212763147.114725: WEXT: Operstate: linkmode=1, operstate=5
> 1212763147.117011: Own MAC address: 00:1d:e0:3e:80:e1
> 1212763147.117018: wpa_driver_wext_set_wpa
> 1212763147.117025: wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
> 1212763147.120005: wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
> 1212763147.120011: wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
> 1212763147.120016: wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
> 1212763147.120020: wpa_driver_wext_set_countermeasures
> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 4 value 0x0 - 1212763147.120079: wpa_driver_wext_set_drop_unencrypted
> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 5 value 0x1 - 1212763147.120088: RSN: flushing PMKID list in the driver
> 1212763147.120099: Setting scan request: 0 sec 100000 usec
> 1212763147.121846: EAPOL: SUPP_PAE entering state DISCONNECTED
> 1212763147.121852: EAPOL: KEY_RX entering state NO_KEY_RECEIVE
> 1212763147.121856: EAPOL: SUPP_BE entering state INITIALIZE
> 1212763147.121862: EAP: EAP entering state DISABLED
> 1212763147.121943: Added interface wlan0
> 1212763147.121962: Ignore event for foreign ifindex 3
> 1212763147.121967: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> 1212763147.121972: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1212763147.121978: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> 1212763147.121982: Wireless event: cmd=0x8b06 len=12
> 1212763147.221020: State: DISCONNECTED -> SCANNING
> 1212763147.221042: Starting AP scan (specific SSID)
> 1212763147.221045: Scan SSID - hexdump_ascii(len=5):
>      64 6c 69 6e 6b                                    dlink
> 1212763147.221053: Trying to get current scan results first without requesting a new scan to speed up initial association
> 1212763147.221076: Received 0 bytes of scan results (0 BSSes)
> 1212763147.221092: CTRL-EVENT-SCAN-RESULTS
> 1212763147.221096: Selecting BSS from priority group 0
> 1212763147.221100: Try to find WPA-enabled AP
> 1212763147.221103: Try to find non-WPA AP
> 1212763147.221106: No suitable AP found.
> 1212763147.221109: Setting scan request: 0 sec 0 usec
> 1212763147.221118: Starting AP scan (broadcast SSID)
> 1212763147.221144: Scan requested (ret=0) - scan timeout 5 seconds
> 1212763148.123014: EAPOL: disable timer tick
> 1212763149.305979: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> 1212763149.306027: Wireless event: cmd=0x8b19 len=16
> 1212763149.306078: Received 299 bytes of scan results (1 BSSes)
> 1212763149.306096: CTRL-EVENT-SCAN-RESULTS
> 1212763149.306104: Selecting BSS from priority group 0
> 1212763149.306123: Try to find WPA-enabled AP
> 1212763149.306132: 0: 00:19:5b:51:dc:27 ssid='dlink' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
> 1212763149.306160:    selected based on RSN IE
> 1212763149.306167:    selected WPA AP 00:19:5b:51:dc:27 ssid='dlink'
> 1212763149.306177: Try to find non-WPA AP
> 1212763149.306190: Trying to associate with 00:19:5b:51:dc:27 (SSID='dlink' freq=2472 MHz)
> 1212763149.306200: Cancelling scan request
> 1212763149.306207: WPA: clearing own WPA/RSN IE
> 1212763149.306214: Automatic auth_alg selection: 0x1
> 1212763149.306234: RSN: using IEEE 802.11i/D9.0
> 1212763149.306243: WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 2
> 1212763149.306256: WPA: clearing AP WPA IE
> 1212763149.306263: WPA: set AP RSN IE - hexdump(len=26): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1212763149.306286: WPA: using GTK TKIP
> 1212763149.306294: WPA: using PTK CCMP
> 1212763149.306302: WPA: using KEY_MGMT WPA-PSK
> 1212763149.306310: WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1212763149.306330: No keys have been configured - skip key clearing
> 1212763149.306338: wpa_driver_wext_set_drop_unencrypted
> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 5 value 0x1 - 1212763149.306381: State: SCANNING -> ASSOCIATING
> 1212763149.306389: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> 1212763149.306397: WEXT: Operstate: linkmode=-1, operstate=5
> 1212763149.306421: wpa_driver_wext_associate
> 1212763149.310563: Setting authentication timeout: 10 sec 0 usec
> 1212763149.310612: EAPOL: External notification - EAP success=0
> 1212763149.310626: EAPOL: External notification - EAP fail=0
> 1212763149.310636: EAPOL: External notification - portControl=Auto
> 1212763149.310649: RSN: Ignored PMKID candidate without preauth flag
> 1212763149.310682: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> 1212763149.310694: Wireless event: cmd=0x8b06 len=12
> 1212763149.310706: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> 1212763149.310715: Wireless event: cmd=0x8b04 len=16
> 1212763149.310726: RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
> 1212763149.310734: Wireless event: cmd=0x8b1a len=21
> 1212763149.519153: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1212763149.519184: Wireless event: cmd=0x8b15 len=24
> 1212763149.519194: Wireless event: new AP: 00:19:5b:51:dc:27
> 1212763149.519206: State: ASSOCIATING -> ASSOCIATED
> 1212763149.519216: wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> 1212763149.519226: WEXT: Operstate: linkmode=-1, operstate=5
> 1212763149.530138: Associated to a new BSS: BSSID=00:19:5b:51:dc:27
> 1212763149.530157: No keys have been configured - skip key clearing
> 1212763149.530169: Associated with 00:19:5b:51:dc:27
> 1212763149.530233: WPA: Association event - clear replay counter
> 1212763149.530244: EAPOL: External notification - portEnabled=0
> 1212763149.530271: EAPOL: External notification - portValid=0
> 1212763149.530279: EAPOL: External notification - EAP success=0
> 1212763149.530287: EAPOL: External notification - portEnabled=1
> 1212763149.530294: EAPOL: SUPP_PAE entering state CONNECTING
> 1212763149.530301: EAPOL: enable timer tick
> 1212763149.530311: EAPOL: SUPP_BE entering state IDLE
> 1212763149.530322: Setting authentication timeout: 10 sec 0 usec
> 1212763149.530333: Cancelling scan request
> 1212763149.530345: RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> 1212763149.530357: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1212763152.515014: RX EAPOL from 00:19:5b:51:dc:27
> 1212763152.515048: RX EAPOL - hexdump(len=99): 01 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 68 f3 84 11 be 67 17 79 50 a3 97 e9 a5 89 82 5a 9b 08 04 58 b5 e4 ad a5 22 ea 94 70 b6 82 42 97 35 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1212763152.515091: Setting authentication timeout: 10 sec 0 usec
> 1212763152.515106: IEEE 802.1X RX: version=1 type=3 length=95
> 1212763152.515114:   EAPOL-Key type=2
> 1212763152.515133:   key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
> 1212763152.515145:   key_length=16 key_data_length=0
> 1212763152.515154:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 68
> 1212763152.515158:   key_nonce - hexdump(len=32): f3 84 11 be 67 17 79 50 a3 97 e9 a5 89 82 5a 9b 08 04 58 b5 e4 ad a5 22 ea 94 70 b6 82 42 97 35
> 1212763152.515166:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1212763152.515171:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1212763152.515176:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1212763152.515180:   key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1212763152.515188: WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 68 f3 84 11 be 67 17 79 50 a3 97 e9 a5 89 82 5a 9b 08 04 58 b5 e4 ad a5 22 ea 94 70 b6 82 42 97 35 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1212763152.515213: State: ASSOCIATED -> 4WAY_HANDSHAKE
> 1212763152.515217: WPA: RX message 1 of 4-Way Handshake from 00:19:5b:51:dc:27 (ver=2)
> 1212763152.515221: RSN: msg 1/4 key data - hexdump(len=0):
> 1212763152.515883: WPA: Renewed SNonce - hexdump(len=32): ac 4d 7a ca 6a 9b 0e 61 95 80 01 39 30 18 71 30 2d 20 69 a7 73 08 0c f2 99 03 aa 53 0a 89 01 50
> 1212763152.515905: WPA: PTK derivation - A1=00:1d:e0:3e:80:e1 A2=00:19:5b:51:dc:27
> 1212763152.515910: WPA: PMK - hexdump(len=32): [REMOVED]
> 1212763152.515913: WPA: PTK - hexdump(len=64): [REMOVED]
> 1212763152.515916: WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1212763152.515924: WPA: Sending EAPOL-Key 2/4
> 1212763152.515930: WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 68 ac 4d 7a ca 6a 9b 0e 61 95 80 01 39 30 18 71 30 2d 20 69 a7 73 08 0c f2 99 03 aa 53 0a 89 01 50 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 6f ec ba e2 f6 21 9c f7 f6 f3 09 7f ca 94 7b b3 00 16 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
> 1212763152.516492: RX EAPOL from 00:19:5b:51:dc:27
> 1212763152.516503: RX EAPOL - hexdump(len=179): 01 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 69 f3 84 11 be 67 17 79 50 a3 97 e9 a5 89 82 5a 9b 08 04 58 b5 e4 ad a5 22 ea 94 70 b6 82 42 97 35 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a f7 fa a0 c1 05 c8 0d 00 d4 7a 0b 55 57 fb 9d 00 50 dc 24 80 1b ca c4 a3 51 29 a7 e9 b2 0c 9e 08 9b 43 4e a2 9e 91 df e9 62 79 61 64 f2 98 0b 21 e9 5a 48 60 66 0d 9b ae d5 e9 c9 cb 1b 09 91 92 a2 39 8c e6 8d 8a 29 ff bd 04 d2 f2 50 62 61 ac 98 b1 76 38 d7 f5 ba 92 7e 55 26 ff e1 ae 34 49 a9
> 1212763152.516570: IEEE 802.1X RX: version=1 type=3 length=175
> 1212763152.516573:   EAPOL-Key type=2
> 1212763152.516576:   key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure Encr)
> 1212763152.516581:   key_length=16 key_data_length=80
> 1212763152.516584:   replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 69
> 1212763152.516588:   key_nonce - hexdump(len=32): f3 84 11 be 67 17 79 50 a3 97 e9 a5 89 82 5a 9b 08 04 58 b5 e4 ad a5 22 ea 94 70 b6 82 42 97 35
> 1212763152.516596:   key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 1212763152.516601:   key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1212763152.516605:   key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
> 1212763152.516610:   key_mic - hexdump(len=16): 0a f7 fa a0 c1 05 c8 0d 00 d4 7a 0b 55 57 fb 9d
> 1212763152.516616: WPA: RX EAPOL-Key - hexdump(len=179): 01 03 00 af 02 13 ca 00 10 00 00 00 00 00 00 00 69 f3 84 11 be 67 17 79 50 a3 97 e9 a5 89 82 5a 9b 08 04 58 b5 e4 ad a5 22 ea 94 70 b6 82 42 97 35 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a f7 fa a0 c1 05 c8 0d 00 d4 7a 0b 55 57 fb 9d 00 50 dc 24 80 1b ca c4 a3 51 29 a7 e9 b2 0c 9e 08 9b 43 4e a2 9e 91 df e9 62 79 61 64 f2 98 0b 21 e9 5a 48 60 66 0d 9b ae d5 e9 c9 cb 1b 09 91 92 a2 39 8c e6 8d 8a 29 ff bd 04 d2 f2 50 62 61 ac 98 b1 76 38 d7 f5 ba 92 7e 55 26 ff e1 ae 34 49 a9
> 1212763152.516647: RSN: encrypted key data - hexdump(len=80): dc 24 80 1b ca c4 a3 51 29 a7 e9 b2 0c 9e 08 9b 43 4e a2 9e 91 df e9 62 79 61 64 f2 98 0b 21 e9 5a 48 60 66 0d 9b ae d5 e9 c9 cb 1b 09 91 92 a2 39 8c e6 8d 8a 29 ff bd 04 d2 f2 50 62 61 ac 98 b1 76 38 d7 f5 ba 92 7e 55 26 ff e1 ae 34 49 a9
> 1212763152.516679: WPA: decrypted EAPOL-Key key data - hexdump(len=72): [REMOVED]
> 1212763152.516683: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
> 1212763152.516686: WPA: RX message 3 of 4-Way Handshake from 00:19:5b:51:dc:27 (ver=2)
> 1212763152.516691: WPA: IE KeyData - hexdump(len=72): 30 18 01 00 00 0f ac 02 02 00 00 0f ac 02 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 26 00 0f ac 01 01 00 ab 64 ea 2a 8c 1c 5a 8e e6 e6 39 9b 95 a2 64 44 14 67 f2 01 ee 76 99 37 02 7f 39 2f 61 db 69 0b dd 00 00 00 00 00
> 1212763152.516706: WPA: Sending EAPOL-Key 4/4
> 1212763152.516711: WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00 00 00 00 00 69 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 19 ef 3b 8a 23 ec ce 67 74 87 18 61 1f 8d 8f de 00 00
> 1212763152.516734: WPA: Installing PTK to the driver.
> 1212763152.516738: wpa_driver_wext_set_key: alg=3 key_idx=0 set_tx=1 seq_len=6 key_len=16
> 1212763152.516759: EAPOL: External notification - portValid=1
> 1212763152.516764: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
> 1212763152.516767: RSN: received GTK in pairwise handshake - hexdump(len=34): [REMOVED]
> 1212763152.516770: WPA: Group Key - hexdump(len=32): [REMOVED]
> 1212763152.516774: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=32).
> 1212763152.516777: WPA: RSC - hexdump(len=6): 00 00 00 00 00 00
> 1212763152.516781: wpa_driver_wext_set_key: alg=2 key_idx=1 set_tx=0 seq_len=6 key_len=32
> 1212763152.516790: WPA: Key negotiation completed with 00:19:5b:51:dc:27 [PTK=CCMP GTK=TKIP]
> 1212763152.516794: Cancelling scan request
> 1212763152.516797: Cancelling authentication timeout
> 1212763152.516801: State: GROUP_HANDSHAKE -> COMPLETED
> 1212763152.516806: CTRL-EVENT-CONNECTED - Connection to 00:19:5b:51:dc:27 completed (auth) [id=0 id_str=]
> 1212763152.516809: wpa_driver_wext_set_operstate: operstate 0->1 (UP)
> 1212763152.516813: WEXT: Operstate: linkmode=-1, operstate=6
> 1212763152.520567: EAPOL: External notification - portValid=1
> 1212763152.520574: EAPOL: External notification - EAP success=1
> 1212763152.520578: EAPOL: SUPP_PAE entering state AUTHENTICATING
> 1212763152.520581: EAPOL: SUPP_BE entering state SUCCESS
> 1212763152.520591: EAP: EAP entering state DISABLED
> 1212763152.520595: EAPOL: SUPP_PAE entering state AUTHENTICATED
> 1212763152.520598: EAPOL: SUPP_BE entering state IDLE
> 1212763152.520602: EAPOL authentication completed successfully
> 1212763152.520614: RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
> 1212763152.520620: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
> 1212763152.531758: EAPOL: startWhen --> 0
> 1212763152.531766: EAPOL: disable timer tick
