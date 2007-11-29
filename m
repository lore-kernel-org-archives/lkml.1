Return-Path: <linux-kernel-owner+w=401wt.eu-S933107AbXK2UUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbXK2UUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbXK2UUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:20:18 -0500
Received: from rtr.ca ([76.10.145.34]:1647 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934025AbXK2UUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:20:13 -0500
Message-ID: <474F1EF9.5060306@rtr.ca>
Date: Thu, 29 Nov 2007 15:20:09 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
References: <Pine.LNX.4.44L0.0711291510200.5666-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711291510200.5666-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(resending with condensed version of original syslog)

Alan Stern wrote:
> On Thu, 29 Nov 2007, Mark Lord wrote:
>
>> But the flogging continues multiple times per second
>> until the system is shutdown, so it is "the next bug to fix".
>
> That's not true.  The number of commands sent while probing a device is
> predetermined and strictly limited.
...

Please tell that to my overflowing syslog (see bottom of this post).
But I hope that 2.6.24 does behave better, thanks.

...
> In any case, what you're talking about is a SCSI issue -- not a USB issue.
...

Absolutely. 


[  347.101738] EIP: [strlen+8/17] strlen+0x8/0x11 SS:ESP 0068:f7152e58
[  345.226354] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.226360] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  345.226367] sd 7:0:0:0: [sdc] Sense not available.
[  345.226382] sd 7:0:0:0: [sdc] Write Protect is off
[  345.226386] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  345.226390] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.226471] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[  345.226539] sd 7:0:0:0: Attached scsi generic sg2 type 0
[  347.151887] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  347.151895] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  347.151902] sd 7:0:0:0: [sdc] Sense not available.
[  347.151918] sd 7:0:0:0: [sdc] Write Protect is off
[  347.151922] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  347.151927] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  347.151981] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  347.151985] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  347.151993] sd 7:0:0:0: [sdc] Sense not available.
[  347.152008] sd 7:0:0:0: [sdc] Write Protect is off
[  347.152013] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  347.152017] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  345.279916] sd 7:0:0:0: [sdc] READ CAPACITY failed
[  345.279951] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
...
[ 1128.158739] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1128.158748] sd 7:0:0:0: [sdc] Sense not available.
[ 1128.158765] sd 7:0:0:0: [sdc] Write Protect is off
[ 1128.158770] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1128.158775] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1130.154329] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1130.154338] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1130.154346] sd 7:0:0:0: [sdc] Sense not available.
[ 1130.154362] sd 7:0:0:0: [sdc] Write Protect is off
[ 1130.154366] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1130.154370] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1130.154448] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1130.154453] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1130.154460] sd 7:0:0:0: [sdc] Sense not available.
[ 1130.154491] sd 7:0:0:0: [sdc] Write Protect is off
[ 1130.154496] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1130.154501] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1132.151015] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1132.151025] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1132.151033] sd 7:0:0:0: [sdc] Sense not available.
[ 1132.151050] sd 7:0:0:0: [sdc] Write Protect is off
[ 1132.151054] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1132.151058] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1134.027522] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1134.027528] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1134.027536] sd 7:0:0:0: [sdc] Sense not available.
[ 1134.027552] sd 7:0:0:0: [sdc] Write Protect is off
[ 1134.027558] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1134.027563] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1136.024030] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1136.024038] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1136.024046] sd 7:0:0:0: [sdc] Sense not available.
[ 1136.024097] sd 7:0:0:0: [sdc] Write Protect is off
[ 1136.024101] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1136.024105] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1136.024545] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1136.024548] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1136.024554] sd 7:0:0:0: [sdc] Sense not available.
[ 1136.024578] sd 7:0:0:0: [sdc] Write Protect is off
[ 1136.024582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1136.024586] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1138.020835] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1138.020845] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1138.020854] sd 7:0:0:0: [sdc] Sense not available.
[ 1138.020902] sd 7:0:0:0: [sdc] Write Protect is off
[ 1138.020908] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1138.020913] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1136.144669] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1136.144675] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1136.144683] sd 7:0:0:0: [sdc] Sense not available.
[ 1136.144698] sd 7:0:0:0: [sdc] Write Protect is off
[ 1136.144704] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1136.144709] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1138.141018] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1138.141028] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1138.141035] sd 7:0:0:0: [sdc] Sense not available.
[ 1138.141052] sd 7:0:0:0: [sdc] Write Protect is off
[ 1138.141056] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1138.141061] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1138.141191] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1138.141196] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1138.141204] sd 7:0:0:0: [sdc] Sense not available.
[ 1138.141235] sd 7:0:0:0: [sdc] Write Protect is off
[ 1138.141241] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1138.141245] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1140.137636] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1140.137647] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1140.137654] sd 7:0:0:0: [sdc] Sense not available.
[ 1140.137673] sd 7:0:0:0: [sdc] Write Protect is off
[ 1140.137679] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1140.137684] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1140.137817] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1140.137821] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1140.137829] sd 7:0:0:0: [sdc] Sense not available.
[ 1140.137857] sd 7:0:0:0: [sdc] Write Protect is off
[ 1140.137862] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1140.137866] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1142.134163] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1142.134172] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1142.134179] sd 7:0:0:0: [sdc] Sense not available.
[ 1142.134245] sd 7:0:0:0: [sdc] Write Protect is off
[ 1142.134249] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1142.134253] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1142.134312] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1142.134316] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1142.134324] sd 7:0:0:0: [sdc] Sense not available.
[ 1142.134339] sd 7:0:0:0: [sdc] Write Protect is off
[ 1142.134344] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1142.134349] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1144.130718] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1144.130723] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1144.130727] sd 7:0:0:0: [sdc] Sense not available.
[ 1144.130735] sd 7:0:0:0: [sdc] Write Protect is off
[ 1144.130737] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1144.130741] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1146.007139] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1146.007141] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1146.007145] sd 7:0:0:0: [sdc] Sense not available.
[ 1146.007153] sd 7:0:0:0: [sdc] Write Protect is off
[ 1146.007156] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1146.007158] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1148.004507] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1148.004511] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1148.004515] sd 7:0:0:0: [sdc] Sense not available.
[ 1148.004545] sd 7:0:0:0: [sdc] Write Protect is off
[ 1148.004547] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1148.004549] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1148.004699] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1148.004700] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1148.004703] sd 7:0:0:0: [sdc] Sense not available.
[ 1148.004719] sd 7:0:0:0: [sdc] Write Protect is off
[ 1148.004721] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1148.004723] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1150.001270] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1150.001279] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1150.001287] sd 7:0:0:0: [sdc] Sense not available.
[ 1150.001354] sd 7:0:0:0: [sdc] Write Protect is off
[ 1150.001359] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1150.001363] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1150.001425] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1150.001429] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1150.001437] sd 7:0:0:0: [sdc] Sense not available.
[ 1150.001452] sd 7:0:0:0: [sdc] Write Protect is off
[ 1150.001457] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1150.001461] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1151.997916] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1151.997925] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1151.997932] sd 7:0:0:0: [sdc] Sense not available.
[ 1151.998000] sd 7:0:0:0: [sdc] Write Protect is off
[ 1151.998004] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1151.998008] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1151.998071] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1151.998076] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1151.998083] sd 7:0:0:0: [sdc] Sense not available.
[ 1151.998098] sd 7:0:0:0: [sdc] Write Protect is off
[ 1151.998103] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1151.998108] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1153.994472] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1153.994478] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1153.994481] sd 7:0:0:0: [sdc] Sense not available.
[ 1153.994513] sd 7:0:0:0: [sdc] Write Protect is off
[ 1153.994515] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1153.994517] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1153.994633] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1153.994635] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1153.994638] sd 7:0:0:0: [sdc] Sense not available.
[ 1153.994655] sd 7:0:0:0: [sdc] Write Protect is off
[ 1153.994657] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1153.994659] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1155.991127] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1155.991133] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1155.991137] sd 7:0:0:0: [sdc] Sense not available.
[ 1155.991176] sd 7:0:0:0: [sdc] Write Protect is off
[ 1155.991178] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1155.991180] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1155.991264] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1155.991266] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1155.991268] sd 7:0:0:0: [sdc] Sense not available.
[ 1155.991283] sd 7:0:0:0: [sdc] Write Protect is off
[ 1155.991284] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1155.991286] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1157.987078] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1157.987087] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1157.987094] sd 7:0:0:0: [sdc] Sense not available.
[ 1157.987110] sd 7:0:0:0: [sdc] Write Protect is off
[ 1157.987116] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1157.987120] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1156.110889] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1156.110895] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1156.110903] sd 7:0:0:0: [sdc] Sense not available.
[ 1156.110919] sd 7:0:0:0: [sdc] Write Protect is off
[ 1156.110924] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1156.110928] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1158.107300] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1158.107309] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1158.107317] sd 7:0:0:0: [sdc] Sense not available.
[ 1158.107333] sd 7:0:0:0: [sdc] Write Protect is off
[ 1158.107339] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1158.107344] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1158.107427] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1158.107431] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1158.107438] sd 7:0:0:0: [sdc] Sense not available.
[ 1158.107489] sd 7:0:0:0: [sdc] Write Protect is off
[ 1158.107494] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1158.107499] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1160.104012] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1160.104021] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1160.104028] sd 7:0:0:0: [sdc] Sense not available.
[ 1161.980453] sd 7:0:0:0: [sdc] Write Protect is off
[ 1161.980460] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1161.980465] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1160.104254] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1160.104259] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1160.104266] sd 7:0:0:0: [sdc] Sense not available.
[ 1160.104282] sd 7:0:0:0: [sdc] Write Protect is off
[ 1160.104287] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1160.104292] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1162.100537] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1162.100546] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1162.100554] sd 7:0:0:0: [sdc] Sense not available.
[ 1162.100571] sd 7:0:0:0: [sdc] Write Protect is off
[ 1162.100577] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1162.100581] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1162.100776] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1162.100781] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1162.100788] sd 7:0:0:0: [sdc] Sense not available.
[ 1162.100823] sd 7:0:0:0: [sdc] Write Protect is off
[ 1162.100828] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1162.100833] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1164.097170] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1164.097179] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1164.097186] sd 7:0:0:0: [sdc] Sense not available.
[ 1164.097290] sd 7:0:0:0: [sdc] Write Protect is off
[ 1164.097294] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1164.097298] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1164.097360] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1164.097364] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1164.097372] sd 7:0:0:0: [sdc] Sense not available.
[ 1164.097387] sd 7:0:0:0: [sdc] Write Protect is off
[ 1164.097392] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1164.097396] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1166.093815] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1166.093824] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1166.093831] sd 7:0:0:0: [sdc] Sense not available.
[ 1166.093896] sd 7:0:0:0: [sdc] Write Protect is off
[ 1166.093901] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1166.093904] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1166.093964] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1166.093968] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1166.093976] sd 7:0:0:0: [sdc] Sense not available.
[ 1166.093991] sd 7:0:0:0: [sdc] Write Protect is off
[ 1166.093996] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1166.094000] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1168.090454] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1168.090463] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1168.090470] sd 7:0:0:0: [sdc] Sense not available.
[ 1168.090486] sd 7:0:0:0: [sdc] Write Protect is off
[ 1168.090492] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1168.090496] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1169.966951] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1169.966957] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1169.966965] sd 7:0:0:0: [sdc] Sense not available.
[ 1169.966981] sd 7:0:0:0: [sdc] Write Protect is off
[ 1169.966986] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1169.966990] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1171.963455] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1171.963465] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1171.963472] sd 7:0:0:0: [sdc] Sense not available.
[ 1171.963488] sd 7:0:0:0: [sdc] Write Protect is off
[ 1171.963492] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1171.963497] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1171.963580] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1171.963584] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1171.963590] sd 7:0:0:0: [sdc] Sense not available.
[ 1170.087302] sd 7:0:0:0: [sdc] Write Protect is off
[ 1170.087308] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1170.087312] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1172.083711] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1172.083720] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1172.083727] sd 7:0:0:0: [sdc] Sense not available.
[ 1172.083794] sd 7:0:0:0: [sdc] Write Protect is off
[ 1172.083798] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1172.083802] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1172.083862] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1172.083866] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1172.083873] sd 7:0:0:0: [sdc] Sense not available.
[ 1172.083888] sd 7:0:0:0: [sdc] Write Protect is off
[ 1172.083893] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1172.083898] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1174.080399] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1174.080408] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1174.080415] sd 7:0:0:0: [sdc] Sense not available.
[ 1174.080481] sd 7:0:0:0: [sdc] Write Protect is off
[ 1174.080485] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1174.080489] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1174.080550] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1174.080554] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1174.080561] sd 7:0:0:0: [sdc] Sense not available.
[ 1174.080577] sd 7:0:0:0: [sdc] Write Protect is off
[ 1174.080582] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1174.080587] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1176.077035] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1176.077044] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1176.077052] sd 7:0:0:0: [sdc] Sense not available.
[ 1176.077067] sd 7:0:0:0: [sdc] Write Protect is off
[ 1176.077072] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1176.077076] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1177.953530] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1177.953536] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1177.953544] sd 7:0:0:0: [sdc] Sense not available.
[ 1177.953559] sd 7:0:0:0: [sdc] Write Protect is off
[ 1177.953564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1177.953569] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1179.950038] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1179.950048] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1179.950055] sd 7:0:0:0: [sdc] Sense not available.
[ 1179.950072] sd 7:0:0:0: [sdc] Write Protect is off
[ 1179.950076] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1179.950080] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1179.950141] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1179.950146] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1179.950154] sd 7:0:0:0: [sdc] Sense not available.
[ 1179.950170] sd 7:0:0:0: [sdc] Write Protect is off
[ 1179.950175] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1179.950179] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1181.946621] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1181.946630] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1181.946637] sd 7:0:0:0: [sdc] Sense not available.
[ 1181.946653] sd 7:0:0:0: [sdc] Write Protect is off
[ 1181.946659] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1181.946663] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1181.946721] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1181.946725] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1181.946733] sd 7:0:0:0: [sdc] Sense not available.
[ 1181.946748] sd 7:0:0:0: [sdc] Write Protect is off
[ 1181.946752] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1181.946757] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1183.949931] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1183.949939] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1183.949947] sd 7:0:0:0: [sdc] Sense not available.
[ 1183.950018] sd 7:0:0:0: [sdc] Write Protect is off
[ 1183.950022] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1183.950026] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1183.950086] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1183.950090] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1183.950098] sd 7:0:0:0: [sdc] Sense not available.
[ 1183.950114] sd 7:0:0:0: [sdc] Write Protect is off
[ 1183.950118] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1183.950123] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1185.946612] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1185.946622] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1185.946629] sd 7:0:0:0: [sdc] Sense not available.
[ 1185.946701] sd 7:0:0:0: [sdc] Write Protect is off
[ 1185.946705] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1185.946709] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1185.946772] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1185.946776] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1185.946784] sd 7:0:0:0: [sdc] Sense not available.
[ 1185.946800] sd 7:0:0:0: [sdc] Write Protect is off
[ 1185.946806] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1185.946810] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1187.943209] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1187.943218] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1187.943225] sd 7:0:0:0: [sdc] Sense not available.
[ 1187.943242] sd 7:0:0:0: [sdc] Write Protect is off
[ 1187.943253] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1187.943257] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1186.067097] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1186.067103] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1186.067110] sd 7:0:0:0: [sdc] Sense not available.
[ 1186.067127] sd 7:0:0:0: [sdc] Write Protect is off
[ 1186.067132] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1186.067136] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1188.063471] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1188.063479] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1188.063487] sd 7:0:0:0: [sdc] Sense not available.
[ 1188.063544] sd 7:0:0:0: [sdc] Write Protect is off
[ 1188.063548] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1188.063552] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1188.063611] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1188.063615] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1188.063623] sd 7:0:0:0: [sdc] Sense not available.
[ 1188.063638] sd 7:0:0:0: [sdc] Write Protect is off
[ 1188.063644] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1188.063648] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1190.060108] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1190.060117] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1190.060124] sd 7:0:0:0: [sdc] Sense not available.
[ 1190.060525] sd 7:0:0:0: [sdc] Write Protect is off
[ 1190.060530] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1190.060533] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1190.060941] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1190.060946] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1190.060953] sd 7:0:0:0: [sdc] Sense not available.
[ 1190.060969] sd 7:0:0:0: [sdc] Write Protect is off
[ 1190.060974] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1190.060979] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1192.056767] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1192.056777] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1192.056784] sd 7:0:0:0: [sdc] Sense not available.
[ 1192.056800] sd 7:0:0:0: [sdc] Write Protect is off
[ 1192.056805] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1192.056810] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1193.933274] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1193.933279] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1193.933288] sd 7:0:0:0: [sdc] Sense not available.
[ 1193.933304] sd 7:0:0:0: [sdc] Write Protect is off
[ 1193.933309] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1193.933314] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1195.929747] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1195.929757] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1195.929764] sd 7:0:0:0: [sdc] Sense not available.
[ 1195.929835] sd 7:0:0:0: [sdc] Write Protect is off
[ 1195.929840] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1195.929844] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1195.929906] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1195.929910] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1195.929918] sd 7:0:0:0: [sdc] Sense not available.
[ 1195.929934] sd 7:0:0:0: [sdc] Write Protect is off
[ 1195.929938] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1195.929943] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1197.926388] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1197.926397] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1197.926404] sd 7:0:0:0: [sdc] Sense not available.
[ 1197.926475] sd 7:0:0:0: [sdc] Write Protect is off
[ 1197.926479] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1197.926483] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1197.926545] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1197.926550] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1197.926557] sd 7:0:0:0: [sdc] Sense not available.
[ 1197.926572] sd 7:0:0:0: [sdc] Write Protect is off
[ 1197.926577] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1197.926582] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1199.923130] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1199.923139] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1199.923147] sd 7:0:0:0: [sdc] Sense not available.
[ 1198.046895] sd 7:0:0:0: [sdc] Write Protect is off
[ 1198.046903] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1198.046908] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1198.047010] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1198.047014] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1198.047022] sd 7:0:0:0: [sdc] Sense not available.
[ 1198.047038] sd 7:0:0:0: [sdc] Write Protect is off
[ 1198.047044] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1198.047048] sd 7:0:0:0: [sdc] Assuming drive cache: write through
: Successful su for root by root
: + pts/1 root:root
: (pam_unix) session opened for user root by (uid=0)
: (pam_unix) session closed for user root
y4 main process (3053) killed by TERM signal
y5 main process (3054) killed by TERM signal
y2 main process (3060) killed by TERM signal
y3 main process (3061) killed by TERM signal
y1 main process (3062) killed by TERM signal
y6 main process (3063) killed by TERM signal
root-4337): Received signal 15, shutting down cleanly
root-4337): Exiting
3986]: (pam_unix) session closed for user root
[ 1200.046508] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1200.046513] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1200.046517] sd 7:0:0:0: [sdc] Sense not available.
[ 1200.046525] sd 7:0:0:0: [sdc] Write Protect is off
[ 1200.046527] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1200.046530] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1201.922929] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1201.922932] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1201.922935] sd 7:0:0:0: [sdc] Sense not available.
[ 1201.922943] sd 7:0:0:0: [sdc] Write Protect is off
[ 1201.922946] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1201.922948] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1203.920304] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1203.920423] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1203.920648] sd 7:0:0:0: [sdc] Sense not available.
[ 1203.923141] sd 7:0:0:0: [sdc] Write Protect is off
[ 1203.923251] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1203.923364] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1203.925791] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1203.925901] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1203.926127] sd 7:0:0:0: [sdc] Sense not available.
[ 1203.926989] sd 7:0:0:0: [sdc] Write Protect is off
[ 1203.927103] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1203.927215] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1205.916257] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1205.916385] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1205.916622] sd 7:0:0:0: [sdc] Sense not available.
[ 1204.040589] sd 7:0:0:0: [sdc] Write Protect is off
[ 1204.040713] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1204.040832] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1204.041249] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1204.041370] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1204.041609] sd 7:0:0:0: [sdc] Sense not available.
[ 1204.041835] sd 7:0:0:0: [sdc] Write Protect is off
[ 1204.041956] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1204.042076] sd 7:0:0:0: [sdc] Assuming drive cache: write through
sd[3522]: Closing acpid connection 
sd[3522]: Closing control socket 
sd[3522]: ATI External Events Daemon shutting down 
[ 1206.036416] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1206.036534] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1206.036775] sd 7:0:0:0: [sdc] Sense not available.
[ 1206.036898] sd 7:0:0:0: [sdc] Write Protect is off
[ 1206.037125] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1206.037250] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[ 1206.038500] sd 7:0:0:0: [sdc] READ CAPACITY failed
[ 1206.038744] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[ 1206.039008] sd 7:0:0:0: [sdc] Sense not available.
[ 1206.040303] sd 7:0:0:0: [sdc] Write Protect is off
[ 1206.040534] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1206.040647] sd 7:0:0:0: [sdc] Assuming drive cache: write through
d[3745]: Caught signal 15, un-registering and exiting.
