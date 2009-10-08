Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbZJHUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbZJHUid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbZJHUib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:38:31 -0400
Received: from n20.bullet.mail.ukl.yahoo.com ([87.248.110.137]:24372 "HELO
	n20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759581AbZJHUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:38:30 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 16:38:29 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 292871.13326.bm@omp208.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=y32/yTFE0r7RRDIa14PoO+93YDPRsSCJQH9FJSlqgJk17fbZtn3wZz/rOWGxq6v6WIjvsemLLdqvpWTzaOEoAFSIZuAO0rVyxyf3pRyg8R1vS4H7g7bqfuczOTxSeVvaTsvJAWt5G4pnIxEaJHKD39kVNpSrXFuH/99xkZQ5Es0=;
Message-ID: <119632.18101.qm@web26701.mail.ukl.yahoo.com>
X-YMail-OSG: tqwKNlQVM1kixuwLgCj4c3DsKWYIPssoQ5JI5yYgXuMOhyoB9LACZfoHk64fInNIlpHcwoKgyIfCqqLnx0cfGTuP_TEkdtmI9wuffikiR7sej7vmK6YRi4B19LX9BvzioFPY0NRcKR6u887y.HmMgpe4WtJ7NF7l5EabmsXRP.s.XW8BLySEsUeugSuaDWn0w9VBS1xCzLNX_kZF_4BmdIO03ikVgOESBSawTVhnc2gksL4Iu98.fq8NUzAgI3dYSwGibuMRiVglCQwh9grCTPvCKR.sskuhx1auRuyGIVkJR_zmuKcrUufeJBpGIA2S4_gcbKSB4ln0rRiNjyQ6u3cM1ZZJLxHtY.VV44plGvTnL4VryW2HUcJ4xQ--
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Thu, 8 Oct 2009 20:30:58 +0000 (GMT)
From: James Gallagher <jbgallagher2000@yahoo.co.uk>
Subject: Kernel doesn't generate a "Discharging" battery event after unplugging AC power on Full battery
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1430399248-1255033858=:18101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1430399248-1255033858=:18101
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

(This applies to kernel 2.6.31.2 and older)=0A=0AIf I unplug AC power on an=
 Acer Aspire One with fully charged battery, the kernel/udev events generat=
ed indicate the only change as POWER_SUPPLY_ONLINE=3D0 (from 1), the batter=
y POWER_SUPPLY_STATUS is still indicating FULL, and no change in the batter=
y environment, even though the event is labelled ACTION=3Dchange on both th=
e mains (ACAD) and battery (BAT1) (see attached log of the 4 kernel/udev ev=
ents generated after unplugging)=0A=0AThis causes DeviceKit-power to suspen=
d polling, so the power manager never records the subsequent discharge of t=
he battery (the battery state in /sys updates to "Discharging" about 10 sec=
onds later). The redhat guys on bugzilla are insisting it's a kernel/udev b=
ug, not a DeviceKit-power bug.=0A=0AThis also occurs on a Dell Inspiron 152=
0, but less predictably - ie sometimes the battery STATE=3DDischarging and =
sometimes =3DFULL.=0A=0ASo Questions?=0A=0A1. Why does the kernel generate =
a change event for the battery when there is no change?=0A2. Why does the b=
attery STATE indicate Full rather than Discharging?=0A3. Why does it take ~=
10 seconds for the battery state to change to "Discharging" in /sys, and wh=
y is there no accompanying udev event to indicate the status change?=0A=0AS=
ee https://bugzilla.redhat.com/show_bug.cgi?id=3D521874 (bug has been re-as=
signed from DeviceKit-power to Kernel)=0A=0AJames Gallagher=0A=0A(can repli=
es be cc'ed to me, cheers)=0A=0A=0A      
--0-1430399248-1255033858=:18101
Content-Type: text/plain; name=udev
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="udev monitor.txt"

JCBzdWRvIHVkZXZhZG0gbW9uaXRvciAtLXVkZXYgLS1rZXJuZWwgLS1lbnZp
cm9ubWVudAptb25pdG9yIHdpbGwgcHJpbnQgdGhlIHJlY2VpdmVkIGV2ZW50
cyBmb3I6ClVERVYgLSB0aGUgZXZlbnQgd2hpY2ggdWRldiBzZW5kcyBvdXQg
YWZ0ZXIgcnVsZSBwcm9jZXNzaW5nCktFUk5FTCAtIHRoZSBrZXJuZWwgdWV2
ZW50CgpLRVJORUxbMTI1NDkzMTUzNy44NTA5MTNdIGNoYW5nZSAgIC9kZXZp
Y2VzL0xOWFNZU1RNOjAwL2RldmljZTowMC9BQ1BJMDAwMzowMC9wb3dlcl9z
dXBwbHkvQUNBRCAocG93ZXJfc3VwcGx5KQpVREVWX0xPRz0zCkFDVElPTj1j
aGFuZ2UKREVWUEFUSD0vZGV2aWNlcy9MTlhTWVNUTTowMC9kZXZpY2U6MDAv
QUNQSTAwMDM6MDAvcG93ZXJfc3VwcGx5L0FDQUQKU1VCU1lTVEVNPXBvd2Vy
X3N1cHBseQpQT1dFUl9TVVBQTFlfTkFNRT1BQ0FEClBPV0VSX1NVUFBMWV9U
WVBFPU1haW5zClBPV0VSX1NVUFBMWV9PTkxJTkU9MApTRVFOVU09MTI0NwoK
VURFViAgWzEyNTQ5MzE1MzcuODk2ODYzXSBjaGFuZ2UgICAvZGV2aWNlcy9M
TlhTWVNUTTowMC9kZXZpY2U6MDAvQUNQSTAwMDM6MDAvcG93ZXJfc3VwcGx5
L0FDQUQgKHBvd2VyX3N1cHBseSkKVURFVl9MT0c9MwpBQ1RJT049Y2hhbmdl
CkRFVlBBVEg9L2RldmljZXMvTE5YU1lTVE06MDAvZGV2aWNlOjAwL0FDUEkw
MDAzOjAwL3Bvd2VyX3N1cHBseS9BQ0FEClNVQlNZU1RFTT1wb3dlcl9zdXBw
bHkKUE9XRVJfU1VQUExZX05BTUU9QUNBRApQT1dFUl9TVVBQTFlfVFlQRT1N
YWlucwpQT1dFUl9TVVBQTFlfT05MSU5FPTAKU0VRTlVNPTEyNDcKCktFUk5F
TFsxMjU0OTMxNTM4LjU1NTQxN10gY2hhbmdlICAgL2RldmljZXMvTE5YU1lT
VE06MDAvZGV2aWNlOjAwL1BOUDBDMEE6MDAvcG93ZXJfc3VwcGx5L0JBVDEg
KHBvd2VyX3N1cHBseSkKVURFVl9MT0c9MwpBQ1RJT049Y2hhbmdlCkRFVlBB
VEg9L2RldmljZXMvTE5YU1lTVE06MDAvZGV2aWNlOjAwL1BOUDBDMEE6MDAv
cG93ZXJfc3VwcGx5L0JBVDEKU1VCU1lTVEVNPXBvd2VyX3N1cHBseQpQT1dF
Ul9TVVBQTFlfTkFNRT1CQVQxClBPV0VSX1NVUFBMWV9UWVBFPUJhdHRlcnkK
UE9XRVJfU1VQUExZX1NUQVRVUz1GdWxsClBPV0VSX1NVUFBMWV9QUkVTRU5U
PTEKUE9XRVJfU1VQUExZX1RFQ0hOT0xPR1k9TGktaW9uClBPV0VSX1NVUFBM
WV9WT0xUQUdFX01JTl9ERVNJR049MTExMDAwMDAKUE9XRVJfU1VQUExZX1ZP
TFRBR0VfTk9XPTEyNTg0MDAwClBPV0VSX1NVUFBMWV9DVVJSRU5UX05PVz02
NTE2MzAwMApQT1dFUl9TVVBQTFlfQ0hBUkdFX0ZVTExfREVTSUdOPTI0MDAw
MDAKUE9XRVJfU1VQUExZX0NIQVJHRV9GVUxMPTExMTEwMDAKUE9XRVJfU1VQ
UExZX0NIQVJHRV9OT1c9MTExMTAwMApQT1dFUl9TVVBQTFlfTU9ERUxfTkFN
RT1VTTA4QTcyClBPV0VSX1NVUFBMWV9NQU5VRkFDVFVSRVI9U0lNUExPClBP
V0VSX1NVUFBMWV9TRVJJQUxfTlVNQkVSPTFDOEMKU0VRTlVNPTEyNDgKClVE
RVYgIFsxMjU0OTMxNTM4LjU2MzA0Nl0gY2hhbmdlICAgL2RldmljZXMvTE5Y
U1lTVE06MDAvZGV2aWNlOjAwL1BOUDBDMEE6MDAvcG93ZXJfc3VwcGx5L0JB
VDEgKHBvd2VyX3N1cHBseSkKVURFVl9MT0c9MwpBQ1RJT049Y2hhbmdlCkRF
VlBBVEg9L2RldmljZXMvTE5YU1lTVE06MDAvZGV2aWNlOjAwL1BOUDBDMEE6
MDAvcG93ZXJfc3VwcGx5L0JBVDEKU1VCU1lTVEVNPXBvd2VyX3N1cHBseQpQ
T1dFUl9TVVBQTFlfTkFNRT1CQVQxClBPV0VSX1NVUFBMWV9UWVBFPUJhdHRl
cnkKUE9XRVJfU1VQUExZX1NUQVRVUz1GdWxsClBPV0VSX1NVUFBMWV9QUkVT
RU5UPTEKUE9XRVJfU1VQUExZX1RFQ0hOT0xPR1k9TGktaW9uClBPV0VSX1NV
UFBMWV9WT0xUQUdFX01JTl9ERVNJR049MTExMDAwMDAKUE9XRVJfU1VQUExZ
X1ZPTFRBR0VfTk9XPTEyNTg0MDAwClBPV0VSX1NVUFBMWV9DVVJSRU5UX05P
Vz02NTE2MzAwMApQT1dFUl9TVVBQTFlfQ0hBUkdFX0ZVTExfREVTSUdOPTI0
MDAwMDAKUE9XRVJfU1VQUExZX0NIQVJHRV9GVUxMPTExMTEwMDAKUE9XRVJf
U1VQUExZX0NIQVJHRV9OT1c9MTExMTAwMApQT1dFUl9TVVBQTFlfTU9ERUxf
TkFNRT1VTTA4QTcyClBPV0VSX1NVUFBMWV9NQU5VRkFDVFVSRVI9U0lNUExP
ClBPV0VSX1NVUFBMWV9TRVJJQUxfTlVNQkVSPTFDOEMKU0VRTlVNPTEyNDgK
Cgo=

--0-1430399248-1255033858=:18101--

