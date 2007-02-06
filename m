Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXBFUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXBFUwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965446AbXBFUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:52:31 -0500
Received: from mail.icabo.tv.br ([200.220.202.3]:39987 "EHLO mail.icabo.tv.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965449AbXBFUwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:52:30 -0500
Message-ID: <45C8EA79.1030309@fliagreco.com.ar>
Date: Tue, 06 Feb 2007 17:52:09 -0300
From: Pablo Sebastian Greco <lkml@fliagreco.com.ar>
User-Agent: Thunderbird 3.0a1 (Windows/20070206)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Marc Donner <donner@dbd-breitband.de>, linux-kernel@vger.kernel.org
Subject: Re: cpu load balancing problem on smp
References: <200702061832.17771.donner@dbd-breitband.de> <1170785364.7324.31.camel@laptopd505.fenrus.org> <200702061941.32907.donner@dbd-breitband.de> <45C8CC2A.90403@linux.intel.com> <45C8DD9E.7010309@fliagreco.com.ar> <45C8E112.9070701@linux.intel.com>
In-Reply-To: <45C8E112.9070701@linux.intel.com>
Content-Type: multipart/mixed;
 boundary="------------060304030609060605090306"
X-ICABO-MailScanner-Information: Please contact the ISP for more information
X-ICABO-MailScanner: Sem Virus encontrado
X-MailScanner-From: lkml@fliagreco.com.ar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060304030609060605090306
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> Pablo Sebastian Greco wrote:
>
>> 2296:        427        426        436  134563009   PCI-MSI-edge      
>> eth1
>> 2297:        252        252  135926471        257   PCI-MSI-edge      
>> eth0
>
> this suggests that  cores would be busy rather than only one....
> -
Yes, but you are looking at mm kernel statistics, but if you look at the 
standard kernel, you'll see that eth interrupts are on the same core 
according to attached /proc/cpuinfo.
OTOH, take a look at timer interrupt distribution

--------------060304030609060605090306
Content-Type: text/plain;
 name="cpuinfo.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="cpuinfo.txt"

cHJvY2Vzc29yICAgICAgIDogMA0KdmVuZG9yX2lkICAgICAgIDogR2VudWluZUludGVsDQpj
cHUgZmFtaWx5ICAgICAgOiAxNQ0KbW9kZWwgICAgICAgICAgIDogNg0KbW9kZWwgbmFtZSAg
ICAgIDogICAgICAgICAgICAgICAgICAgSW50ZWwoUikgWGVvbihUTSkgQ1BVIDIuNjZHSHoN
CnN0ZXBwaW5nICAgICAgICA6IDQNCmNwdSBNSHogICAgICAgICA6IDI2NTYuMDAwDQpjYWNo
ZSBzaXplICAgICAgOiAyMDQ4IEtCDQpwaHlzaWNhbCBpZCAgICAgOiAwDQpzaWJsaW5ncyAg
ICAgICAgOiA0DQpjb3JlIGlkICAgICAgICAgOiAwDQpjcHUgY29yZXMgICAgICAgOiAyDQpm
cHUgICAgICAgICAgICAgOiB5ZXMNCmZwdV9leGNlcHRpb24gICA6IHllcw0KY3B1aWQgbGV2
ZWwgICAgIDogNg0Kd3AgICAgICAgICAgICAgIDogeWVzDQpmbGFncyAgICAgICAgICAgOiBm
cHUgdm1lIGRlIHBzZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1j
YSBjbW92IHBhdCBwc2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNz
IGh0IHRtIHN5c2NhbGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2NwbCB2
bXggZXN0IGNpZCBjeDE2IHh0cHIgbGFoZl9sbQ0KYm9nb21pcHMgICAgICAgIDogNTMyNC44
Mg0KY2xmbHVzaCBzaXplICAgIDogNjQNCmNhY2hlX2FsaWdubWVudCA6IDEyOA0KYWRkcmVz
cyBzaXplcyAgIDogMzYgYml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFsDQpwb3dlciBt
YW5hZ2VtZW50Og0KDQpwcm9jZXNzb3IgICAgICAgOiAxDQp2ZW5kb3JfaWQgICAgICAgOiBH
ZW51aW5lSW50ZWwNCmNwdSBmYW1pbHkgICAgICA6IDE1DQptb2RlbCAgICAgICAgICAgOiA2
DQptb2RlbCBuYW1lICAgICAgOiAgICAgICAgICAgICAgICAgICBJbnRlbChSKSBYZW9uKFRN
KSBDUFUgMi42NkdIeg0Kc3RlcHBpbmcgICAgICAgIDogNA0KY3B1IE1IeiAgICAgICAgIDog
MjY1Ni4wMDANCmNhY2hlIHNpemUgICAgICA6IDIwNDggS0INCnBoeXNpY2FsIGlkICAgICA6
IDANCnNpYmxpbmdzICAgICAgICA6IDQNCmNvcmUgaWQgICAgICAgICA6IDENCmNwdSBjb3Jl
cyAgICAgICA6IDINCmZwdSAgICAgICAgICAgICA6IHllcw0KZnB1X2V4Y2VwdGlvbiAgIDog
eWVzDQpjcHVpZCBsZXZlbCAgICAgOiA2DQp3cCAgICAgICAgICAgICAgOiB5ZXMNCmZsYWdz
ICAgICAgICAgICA6IGZwdSB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1jZSBjeDggYXBpYyBz
ZXAgbXRyciBwZ2UgbWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFjcGkgbW14IGZ4
c3Igc3NlIHNzZTIgc3MgaHQgdG0gc3lzY2FsbCBueCBsbSBjb25zdGFudF90c2MgcG5pIG1v
bml0b3IgZHNfY3BsIHZteCBlc3QgY2lkIGN4MTYgeHRwciBsYWhmX2xtDQpib2dvbWlwcyAg
ICAgICAgOiA1MzIwLjA2DQpjbGZsdXNoIHNpemUgICAgOiA2NA0KY2FjaGVfYWxpZ25tZW50
IDogMTI4DQphZGRyZXNzIHNpemVzICAgOiAzNiBiaXRzIHBoeXNpY2FsLCA0OCBiaXRzIHZp
cnR1YWwNCnBvd2VyIG1hbmFnZW1lbnQ6DQoNCnByb2Nlc3NvciAgICAgICA6IDINCnZlbmRv
cl9pZCAgICAgICA6IEdlbnVpbmVJbnRlbA0KY3B1IGZhbWlseSAgICAgIDogMTUNCm1vZGVs
ICAgICAgICAgICA6IDYNCm1vZGVsIG5hbWUgICAgICA6ICAgICAgICAgICAgICAgICAgIElu
dGVsKFIpIFhlb24oVE0pIENQVSAyLjY2R0h6DQpzdGVwcGluZyAgICAgICAgOiA0DQpjcHUg
TUh6ICAgICAgICAgOiAyNjU2LjAwMA0KY2FjaGUgc2l6ZSAgICAgIDogMjA0OCBLQg0KcGh5
c2ljYWwgaWQgICAgIDogMA0Kc2libGluZ3MgICAgICAgIDogNA0KY29yZSBpZCAgICAgICAg
IDogMA0KY3B1IGNvcmVzICAgICAgIDogMg0KZnB1ICAgICAgICAgICAgIDogeWVzDQpmcHVf
ZXhjZXB0aW9uICAgOiB5ZXMNCmNwdWlkIGxldmVsICAgICA6IDYNCndwICAgICAgICAgICAg
ICA6IHllcw0KZmxhZ3MgICAgICAgICAgIDogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUg
bWNlIGN4OCBhcGljIHNlcCBtdHJyIHBnZSBtY2EgY21vdiBwYXQgcHNlMzYgY2xmbHVzaCBk
dHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyBodCB0bSBzeXNjYWxsIG54IGxtIGNvbnN0
YW50X3RzYyBwbmkgbW9uaXRvciBkc19jcGwgdm14IGVzdCBjaWQgY3gxNiB4dHByIGxhaGZf
bG0NCmJvZ29taXBzICAgICAgICA6IDUzMjAuMjANCmNsZmx1c2ggc2l6ZSAgICA6IDY0DQpj
YWNoZV9hbGlnbm1lbnQgOiAxMjgNCmFkZHJlc3Mgc2l6ZXMgICA6IDM2IGJpdHMgcGh5c2lj
YWwsIDQ4IGJpdHMgdmlydHVhbA0KcG93ZXIgbWFuYWdlbWVudDoNCg0KcHJvY2Vzc29yICAg
ICAgIDogMw0KdmVuZG9yX2lkICAgICAgIDogR2VudWluZUludGVsDQpjcHUgZmFtaWx5ICAg
ICAgOiAxNQ0KbW9kZWwgICAgICAgICAgIDogNg0KbW9kZWwgbmFtZSAgICAgIDogICAgICAg
ICAgICAgICAgICAgSW50ZWwoUikgWGVvbihUTSkgQ1BVIDIuNjZHSHoNCnN0ZXBwaW5nICAg
ICAgICA6IDQNCmNwdSBNSHogICAgICAgICA6IDI2NTYuMDAwDQpjYWNoZSBzaXplICAgICAg
OiAyMDQ4IEtCDQpwaHlzaWNhbCBpZCAgICAgOiAwDQpzaWJsaW5ncyAgICAgICAgOiA0DQpj
b3JlIGlkICAgICAgICAgOiAxDQpjcHUgY29yZXMgICAgICAgOiAyDQpmcHUgICAgICAgICAg
ICAgOiB5ZXMNCmZwdV9leGNlcHRpb24gICA6IHllcw0KY3B1aWQgbGV2ZWwgICAgIDogNg0K
d3AgICAgICAgICAgICAgIDogeWVzDQpmbGFncyAgICAgICAgICAgOiBmcHUgdm1lIGRlIHBz
ZSB0c2MgbXNyIHBhZSBtY2UgY3g4IGFwaWMgc2VwIG10cnIgcGdlIG1jYSBjbW92IHBhdCBw
c2UzNiBjbGZsdXNoIGR0cyBhY3BpIG1teCBmeHNyIHNzZSBzc2UyIHNzIGh0IHRtIHN5c2Nh
bGwgbnggbG0gY29uc3RhbnRfdHNjIHBuaSBtb25pdG9yIGRzX2NwbCB2bXggZXN0IGNpZCBj
eDE2IHh0cHIgbGFoZl9sbQ0KYm9nb21pcHMgICAgICAgIDogNTMyMC4xNg0KY2xmbHVzaCBz
aXplICAgIDogNjQNCmNhY2hlX2FsaWdubWVudCA6IDEyOA0KYWRkcmVzcyBzaXplcyAgIDog
MzYgYml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFsDQpwb3dlciBtYW5hZ2VtZW50Og0K

--------------060304030609060605090306--
