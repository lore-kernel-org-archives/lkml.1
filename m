Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbXJMFu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbXJMFu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 01:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXJMFuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 01:50:12 -0400
Received: from 0x3e42aafc.adsl.cybercity.dk ([62.66.170.252]:22797 "EHLO
	dawn.lix-world.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbXJMFuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 01:50:10 -0400
Message-ID: <47105C53.7040603@lix-world.net>
Date: Sat, 13 Oct 2007 07:49:07 +0200
From: Steen Eugen Poulsen <sep@lix-world.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; da; rv:1.8.1.6) Gecko/20070921 Thunderbird/2.0.0.6 ThunderBrowse/3.1.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lists@dusted.dk, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
References: <56020.194.255.108.253.1192004925.squirrel@root.dusted.dk> <20071012174153.69556b32.akpm@linux-foundation.org>
In-Reply-To: <20071012174153.69556b32.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms010800000600050606060709"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010800000600050606060709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton skrev:
> On Wed, 10 Oct 2007 10:28:45 +0200 (CEST)
> lists@dusted.dk wrote:
> 
>> I get this on brand new hardware, 2xHitachi Deathstar 320gb SATA2
>> (sata_via driver)

Sep 28 04:32:40 locker ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0
action 0x2 frozen
Sep 28 04:32:40 locker ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00
tag 0 cdb 0x0 data 123392 in
Sep 28 04:32:40 locker res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask
0x202 (HSM violation)
Sep 28 04:32:41 locker  current size: 625140335 sectors

Sep 28 04:32:41 locker  native size: 625142448 sectors

Sep 28 04:32:41 locker  current size: 625140335 sectors

Sep 28 04:32:41 locker  native size: 625142448 sectors

Another machine:

Sep 28 03:47:55 dragonslair ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x0 action 0x2 frozen
Sep 28 03:47:55 dragonslair ata1.00: cmd
b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 126976 in

Sep 28 03:47:55 dragonslair res 50/00:f8:00:4f:c2/00:00:00:00:00/00
Emask 0x202 (HSM violation)
Sep 28 03:47:55 dragonslair ata1: soft resetting port

Sep 28 03:47:55 dragonslair ata1.00: configured for UDMA/133

Sep 28 03:47:55 dragonslair ata1: EH complete

Sep 28 03:47:55 dragonslair sd 0:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Sep 28 03:47:55 dragonslair sd 0:0:0:0: [sda] 156250000 512-byte
hardware sectors (80000 MB)
Sep 28 03:47:55 dragonslair sd 0:0:0:0: [sda] Write Protect is off

Sep 28 03:47:55 dragonslair sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00

Sep 28 03:47:55 dragonslair sd 0:0:0:0: [sda] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA

And yet another:

Sep 28 04:33:52 liferaft kernel: ata1.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x2 frozen
Sep 28 04:33:55 liferaft kernel: ata1.00: cmd
b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
Sep 28 04:33:55 liferaft kernel:          res
50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
Sep 28 04:33:55 liferaft kernel: ata1: soft resetting port
Sep 28 04:33:55 liferaft kernel: ata1: SATA link up 3.0 Gbps (SStatus
123 SControl 300)
Sep 28 04:33:55 liferaft kernel: ata1.00: configured for UDMA/133
Sep 28 04:33:55 liferaft kernel: ata1: EH complete



Another few cases, taken from semi random locations from my log to get
the many different data, maybe some of it can help out.

Weirdness 1: I have 3 machines, that decide to spew this garbage within
the same second? (smartd running at it is around the hour that smartd
would run, but it's just this one day Sep 28 that horrible bad)

Note 1: Bad/failing hardware creates these type of errors.

Note 2: The hardware didn't freeze for me and I believe the freeze is do
to swap breaking due to the errors.

Note 3: dragonslair's harddisk actually crashed, kernel didn't die, it
just remounted read only. Reboot and the disk was missing, more reboot
and the machine started with all disks running again, been stable since
the 28th Sep. (knock on wood)

Note 4: I've changed hardware and kernel in a non controled manner, so I
was waiting for another case of these errors where I would be able to
write down kernel config.

I'm not sure, but I do believe that a keyword with this stuff is SMP and
2.6.22, older kernels doesn't seem to trigger this and non SMP seems to
avoid it with 2.6.22, but I can't trigger the error, so there is no way
of knowing if the conclusion can be trusted.

Dragonslair:
P4 x2 3.0 Ghz
Chips Intel 865GV & ICH5
32bit SMP kernel (2.6.22)
2 SATA disks WDC WD800JD-75MSA3
(I'm guessing this one has a physical bad disk, since it's the only one
the disk has physically failed and the only one with a worrying SMART
error: 1 Raw_Read_Error_Rate 0x000f 200 200 051 Pre-fail Always - 5)

Locker:
AMD 64x2
Chips Nvidia 570
32bit SMP kernel (2.6.22)
6 SATA disks 2xWD3200YS-01PGB0 4xWD3200AAKS-00TMA0

Liferaft:
AMD 64x2
Chips Nvidia 590
32bit SMP kernel (vserver 2.6.22 based)
1 SATA disk WD2500KS-00MJB0


--------------ms010800000600050606060709
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIK7DCC
BXIwggRaoAMCAQICBEOGqWgwDQYJKoZIhvcNAQEFBQAwMTELMAkGA1UEBhMCREsxDDAKBgNV
BAoTA1REQzEUMBIGA1UEAxMLVERDIE9DRVMgQ0EwHhcNMDYwNzI2MTMyNTM1WhcNMDgwNzI2
MTM1NTM1WjB7MQswCQYDVQQGEwJESzEpMCcGA1UEChMgSW5nZW4gb3JnYW5pc2F0b3Jpc2sg
dGlsa255dG5pbmcxQTAaBgNVBAMTE1N0ZWVuIEV1Z2VuIFBvdWxzZW4wIwYDVQQFExxQSUQ6
OTIwOC0yMDAyLTItMzE3NjE3NjE4MTQ5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDl
v74PjpJrPTPfGCsZVhVK+ihTc1gLzPApQLuuAwFkU1YlotH5E92uO6YAGBh0u7Nu89N/N5Ad
JV4v6Hsmr8CZRAm6K/Nib3QsIByUi8VdgCcfD/MPheu8nne/YYQ6Edws3M1vBvY22NHW7Hkd
dtjYNiD2biGQ36eNoLbCTeMClwIDAQABo4ICyjCCAsYwDgYDVR0PAQH/BAQDAgP4MCsGA1Ud
EAQkMCKADzIwMDYwNzI2MTMyNTM1WoEPMjAwODA3MjYxMzU1MzVaMIIBNwYDVR0gBIIBLjCC
ASowggEmBgoqgVCBKQEBAQEDMIIBFjAvBggrBgEFBQcCARYjaHR0cDovL3d3dy5jZXJ0aWZp
a2F0LmRrL3JlcG9zaXRvcnkwgeIGCCsGAQUFBwICMIHVMAoWA1REQzADAgEBGoHGRm9yIGFu
dmVuZGVsc2UgYWYgY2VydGlmaWthdGV0IGfmbGRlciBPQ0VTIHZpbGvlciwgQ1BTIG9nIE9D
RVMgQ1AsIGRlciBrYW4gaGVudGVzIGZyYSB3d3cuY2VydGlmaWthdC5kay9yZXBvc2l0b3J5
LiBCZW3mcmssIGF0IFREQyBlZnRlciB2aWxr5XJlbmUgaGFyIGV0IGJlZ3LmbnNldCBhbnN2
YXIgaWZ0LiBwcm9mZXNzaW9uZWxsZSBwYXJ0ZXIuMEEGCCsGAQUFBwEBBDUwMzAxBggrBgEF
BQcwAYYlaHR0cDovL29jc3AuY2VydGlmaWthdC5kay9vY3NwL3N0YXR1czAcBgNVHREEFTAT
gRFzZXBAbGl4LXdvcmxkLm5ldDCBhAYDVR0fBH0wezBLoEmgR6RFMEMxCzAJBgNVBAYTAkRL
MQwwCgYDVQQKEwNUREMxFDASBgNVBAMTC1REQyBPQ0VTIENBMRAwDgYDVQQDEwdDUkwxNDAz
MCygKqAohiZodHRwOi8vY3JsLm9jZXMuY2VydGlmaWthdC5kay9vY2VzLmNybDAfBgNVHSME
GDAWgBRgtYXsVmR+EhknZx1QFUtzrjv5EjAdBgNVHQ4EFgQUGnA0kYplEvpmQTxbkQMwljvV
XMcwCQYDVR0TBAIwADAZBgkqhkiG9n0HQQAEDDAKGwRWNy4xAwIDqDANBgkqhkiG9w0BAQUF
AAOCAQEAT5wZtMDaWA31Y7uOj4Z1YXx70TbIreJe1IdVGmQCb0X5LCapVCRHtnP0LEOOPZlJ
WuR89jSRz8Ojxi+bR/maVu2bIlP900p+S18TksLsR1k7eiEPDYta8/rz7s5EHwuG00Ts9AiO
4nySH3ra/fqBh3HgUUQCbhLLPAB9YhvHGgxJpdzICzw2g9KzzCLsXqWaGCwb64K46CE9klOX
UIFoQJ82HeJmjzsMy9ULY5c1JwKPbn8AzbxSOrQi3ssGOiuZQ51zqFfXckXGy9GPQigT/IWk
5sqzgVFmD1znzEl9+YITBfBSALKUdHxfkXu+UvOx+CjkWow4eSk/0QiF9DCZejCCBXIwggRa
oAMCAQICBEOGqWgwDQYJKoZIhvcNAQEFBQAwMTELMAkGA1UEBhMCREsxDDAKBgNVBAoTA1RE
QzEUMBIGA1UEAxMLVERDIE9DRVMgQ0EwHhcNMDYwNzI2MTMyNTM1WhcNMDgwNzI2MTM1NTM1
WjB7MQswCQYDVQQGEwJESzEpMCcGA1UEChMgSW5nZW4gb3JnYW5pc2F0b3Jpc2sgdGlsa255
dG5pbmcxQTAaBgNVBAMTE1N0ZWVuIEV1Z2VuIFBvdWxzZW4wIwYDVQQFExxQSUQ6OTIwOC0y
MDAyLTItMzE3NjE3NjE4MTQ5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDlv74PjpJr
PTPfGCsZVhVK+ihTc1gLzPApQLuuAwFkU1YlotH5E92uO6YAGBh0u7Nu89N/N5AdJV4v6Hsm
r8CZRAm6K/Nib3QsIByUi8VdgCcfD/MPheu8nne/YYQ6Edws3M1vBvY22NHW7HkddtjYNiD2
biGQ36eNoLbCTeMClwIDAQABo4ICyjCCAsYwDgYDVR0PAQH/BAQDAgP4MCsGA1UdEAQkMCKA
DzIwMDYwNzI2MTMyNTM1WoEPMjAwODA3MjYxMzU1MzVaMIIBNwYDVR0gBIIBLjCCASowggEm
BgoqgVCBKQEBAQEDMIIBFjAvBggrBgEFBQcCARYjaHR0cDovL3d3dy5jZXJ0aWZpa2F0LmRr
L3JlcG9zaXRvcnkwgeIGCCsGAQUFBwICMIHVMAoWA1REQzADAgEBGoHGRm9yIGFudmVuZGVs
c2UgYWYgY2VydGlmaWthdGV0IGfmbGRlciBPQ0VTIHZpbGvlciwgQ1BTIG9nIE9DRVMgQ1As
IGRlciBrYW4gaGVudGVzIGZyYSB3d3cuY2VydGlmaWthdC5kay9yZXBvc2l0b3J5LiBCZW3m
cmssIGF0IFREQyBlZnRlciB2aWxr5XJlbmUgaGFyIGV0IGJlZ3LmbnNldCBhbnN2YXIgaWZ0
LiBwcm9mZXNzaW9uZWxsZSBwYXJ0ZXIuMEEGCCsGAQUFBwEBBDUwMzAxBggrBgEFBQcwAYYl
aHR0cDovL29jc3AuY2VydGlmaWthdC5kay9vY3NwL3N0YXR1czAcBgNVHREEFTATgRFzZXBA
bGl4LXdvcmxkLm5ldDCBhAYDVR0fBH0wezBLoEmgR6RFMEMxCzAJBgNVBAYTAkRLMQwwCgYD
VQQKEwNUREMxFDASBgNVBAMTC1REQyBPQ0VTIENBMRAwDgYDVQQDEwdDUkwxNDAzMCygKqAo
hiZodHRwOi8vY3JsLm9jZXMuY2VydGlmaWthdC5kay9vY2VzLmNybDAfBgNVHSMEGDAWgBRg
tYXsVmR+EhknZx1QFUtzrjv5EjAdBgNVHQ4EFgQUGnA0kYplEvpmQTxbkQMwljvVXMcwCQYD
VR0TBAIwADAZBgkqhkiG9n0HQQAEDDAKGwRWNy4xAwIDqDANBgkqhkiG9w0BAQUFAAOCAQEA
T5wZtMDaWA31Y7uOj4Z1YXx70TbIreJe1IdVGmQCb0X5LCapVCRHtnP0LEOOPZlJWuR89jSR
z8Ojxi+bR/maVu2bIlP900p+S18TksLsR1k7eiEPDYta8/rz7s5EHwuG00Ts9AiO4nySH3ra
/fqBh3HgUUQCbhLLPAB9YhvHGgxJpdzICzw2g9KzzCLsXqWaGCwb64K46CE9klOXUIFoQJ82
HeJmjzsMy9ULY5c1JwKPbn8AzbxSOrQi3ssGOiuZQ51zqFfXckXGy9GPQigT/IWk5sqzgVFm
D1znzEl9+YITBfBSALKUdHxfkXu+UvOx+CjkWow4eSk/0QiF9DCZejGCAiowggImAgEBMDkw
MTELMAkGA1UEBhMCREsxDDAKBgNVBAoTA1REQzEUMBIGA1UEAxMLVERDIE9DRVMgQ0ECBEOG
qWgwCQYFKw4DAhoFAKCCAUcwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMDcxMDEzMDU0OTA3WjAjBgkqhkiG9w0BCQQxFgQUE7CXUveAgjRRhCvPAf17frYN
V2swSAYJKwYBBAGCNxAEMTswOTAxMQswCQYDVQQGEwJESzEMMAoGA1UEChMDVERDMRQwEgYD
VQQDEwtUREMgT0NFUyBDQQIEQ4apaDBKBgsqhkiG9w0BCRACCzE7oDkwMTELMAkGA1UEBhMC
REsxDDAKBgNVBAoTA1REQzEUMBIGA1UEAxMLVERDIE9DRVMgQ0ECBEOGqWgwUgYJKoZIhvcN
AQkPMUUwQzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYF
Kw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEgYCC+n3e+QWjahFfyyUZDqun
K0beiGn9oGppFJXnk00m5IJI4BSQsshTTN3czly8/vK8IJlRxqkdgzkOUwsOQyFFHK9pTkg9
sk9ekNULsbN3MHHoLg9zrsTr6Ys3wo5lFd7zEZSL1+qJ594foRGCHJJ0qakNtJWfgaXcO0cE
QEjOhwAAAAAAAA==
--------------ms010800000600050606060709--
