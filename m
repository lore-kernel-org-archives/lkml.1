Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYDNKwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYDNKwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYDNKwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:52:32 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33183 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbYDNKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:52:31 -0400
Message-ID: <4803375C.3060001@bull.net>
Date: Mon, 14 Apr 2008 12:52:12 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de,
       manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net>	 <1207931235.7157.0.camel@twins>  <4802E93E.4090205@bull.net> <1208157359.7427.25.camel@twins> <480316D3.7070901@bull.net>
In-Reply-To: <480316D3.7070901@bull.net>
Content-Type: multipart/mixed;
 boundary="------------060202070005020606050501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060202070005020606050501
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Nadia Derbey wrote:
> Peter Zijlstra wrote:
> 
>> On Mon, 2008-04-14 at 07:18 +0200, Nadia Derbey wrote:
>>
>>> Peter Zijlstra wrote:
>>>
>>>> On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:
>>>>
>>>>
>>>>> Here is finally the ipc ridr-based implementation I was talking 
>>>>> about last
>>>>> week (see http://lkml.org/lkml/2008/4/4/208).
>>>>> I couldn't avoid much of the code duplication, but at least made 
>>>>> things
>>>>> incremental.
>>>>>
>>>>> Does somebody now a test suite that exists for the idr API, that I 
>>>>> could
>>>>> run on this new api?
>>>>>
>>>>> Mike, can you try to run it on your victim: I had such a hard time 
>>>>> building
>>>>> this patch, that I couldn't re-run the test on my 8-core with this new
>>>>> version. So the last results I have are for 2.6.25-rc3-mm1.
>>>>>
>>>>> Also, I think a careful review should be done to avoid introducing 
>>>>> yet other
>>>>> problems :-(
>>>>
>>>>
>>>>
>>>> Why duplicate the whole thing, when we converted the Radix tree to be
>>>> RCU safe we did it in-place. Is there a reason this is not done for 
>>>> idr?
>>>>
>>>>
>>>>
>>>
>>> I did that because I wanted to go fast and try to fix the performance 
>>> problem we have with sysV ipc's. I didn't want to introduce (yet 
>>> other) regressions in the code that uses idr's today and that works 
>>> well ;-)
>>> May be in the future if this rcu based api appears to be ok, we can 
>>> replace one with the other?
>>
>>
>>
>>> From what I can see the API doesn't change at all,
> 
> 
> Well, 1 interface changes, 1 is added and another one went away:
> 
> 1) for the preload part (it becomes like the radix-tree preload part):
> 
> int idr_pre_get(struct idr *, gfp_t);
> would become
> int idr_pre_get(gfp_t);
> 
> 2) idr_pre_get_end() is added (same as radix_tree_preload_end()).
> 
> 3) The idr_init() disappears.
> 
> You might see that other interfaces are not provided by ridr, but this 
> is only because I've taken those that are useful for the ipc part (so 
> should not be a problem to make the whole thing rcu safe).
> 
>> so I don't see why
>> you need to duplicate - either the new code works as expected or its
>> broken.
> 
> 
> That's why I asked for an "IDR test suite": I wanted to test potential 
> regressions.
> 
>> If it works its good enough for all IDR users, if its broken we
>> should fix it. Seems simple enough.. am I missing something obvious?
>>
> 
> Regards,
> Nadia
> 

BTW, I'm realizing that I forgot to send the results I've got - sorry 
for that (I finally could pass the pmsg/psem tests this morning):

These are the output files for the command:

for i in 1 2 3 4 5 6 7 8;do ./pmsg $i 5;done

pmsg_output.25_rc8_mm1.ref.8: output file for the 2.6.25-rc8-mm1
                               reference kernel
pmsg_output.25_rc8_mm1.ridr.8: output file for the 2.6.25-rc8-mm1
                                refrence kernel, with ipc's using
                                rcu-based idr's
psem_output.25_rc8_mm1.ref.8: same as <1> for the psem test
psem_output.25_rc8_mm1.ridr.8: same as <2> for the psem test

Regards,
Nadia


--------------060202070005020606050501
Content-Type: application/x-redhat-package-manager;
 name="results.tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="results.tar.bz2"

QlpoOTFBWSZTWa64Ms4AJh1/hNwQAIBS4f/wDAAWCv/n/2AAAQAIYBDfe3GRAdChKG2CQBNg
0CgUAAOqAXBgdSlrEEJVPIxGlNQAGgAAAAAaqfsQKhGojAABGm0ATTTBgAAAABoNAGgGgCpq
ilT0NJtFM1GgGmQBoA9TQGAAAAAGg0AaAaAKoICJSRkm2lG1D1NDINGjJoZ+s/mfgfaWcjAT
mIiH9Uwg+uvvXEn1gtePHfHoNuzbbomcEQ0DhAyyyarbmkANLZ77pemHKrbSPDvZYog1ps0X
e97G2yRpRyZG3E2HZJlm6OmIhRug3p0bs67ThKToyWXBpxtdgAAqgtlizEcZwKS6iWLVoW/U
AAMV1SdzEGDLlqVc8uRR8Z89lZlsatqMN7z3m2N/kg2b4DH3f1SXG2nEnHHEnu9Pb8O+nvMd
bn+DF9qTmWIq6cDtncUiZwPUhuOGdlwbc4lt1N5YVyogsiTwmCoo4yWay9oxaxzUmQ721LyK
labEUZ1Mjdx8uQjhA7AAAXElJL3Ni5UnHTaB3q04FxScccSdG6ddS0pOLik6Z1zqk422nCcO
cSrjoTnVVca4pJJOmuKSSRE4LiSqpOuOJOHScdUuLikqpJJJJaUnoCcJJLVa1WiJwAfEMfxB
9x+4IP+wQZB0FhBwsb2eDcCMhDkSODiUzSaRTY4Dpw6hqNqFph026cN1Cm26bdONuzNTYdG6
fEHXhMzwN4OB1ChZCykCiFFERQXQSkUEGO+a0kkkpaSfUD4b32ymW2VlJolskykK2yZJlFmW
2qUkVtrbVEitYsWkVkfaD5A+J9J+E+82fU/SfefaDgPtBBbrXHxWGEpUwwphhT7QQYyympqU
zRSYqrkuc57Tzip9XLXFzcXretTXktKM/PZmUlTKZO5TLqSlOZJdiZ6dOGlTtSkqSpSlRNJp
OsTOkqiVEqTSYrjBLaVEqRg46oqkww4l2lKTM9jHVSqOR0np+mP0A+8D85+d+8dAGAAJAvnw
6AcOrnb63KBronfShTeODA6LiGOnh9Z825WXHEnNHka9tw3wI2IQ2eUIMASIkRFUFBFTCyxQ
hnz9r9rAOudOj6MgczQj6UKERLOamvj1avsW1g0ZKUlKiwtCng2MBHeNOssDM6dcYg27hjYw
0NCxq9J0hjIhWbT5PY8PL1PJ7klVqoraWVsSSSNJJOeHNznOXHzS73ku2qq6mLiIuUpSSmqt
cXMza5l5hvNZxM98xc5m99m71bnOkIJH1PHO1+wydNjKRpwVBL/AiiMgxnk+D7DQ+lE+CliS
5HiUcHhGSMc39PMfDryWUsL0s09FJeDwczOJ40UyKMtE00JSbfGMjQ7GfCRt4YHWELx8uqrr
LlqdLL55vYpmVDa8uvimhLjpo888V6VqNzoVTM9m2GH2YTalRVNCjDJgkkwrBEycZUWneLOJ
51eBOvbxWz1jq9bqSqKpQlq32y0biSSNJJLAAA6s4o8YnjyhdZT51IbJQp1kZzMCJqKF+n0u
UpnojfBKeDRjLwV69Ec81TbqsCbRhpaFqSYlC1DPJnEKlDSTqUS0pzDj45dpW40SPHerS2wb
fFix+Rm4nkHzaqpjFe8HwatkNRq8UPXr4efBNtszxhMZJFD1Oz1LtVWVq3pVnFxbbiSNJS9E
R72rnx8m/MXln33O/mOuY1W+Z1u+O9xrGvCUIucbr4246KSKcesIiVpSyp7h49v3FXfeJlt6
OvHjbKtMjIu/J8vRipicKiqx7b13L1x4tTo5Q8apOHjrjiWvLqeQU4wy44MveLFW7pnI0q2b
aFqrypYT6MrPWdadMD1vJnPKpJqPn1OLmTnDSSIlKWdZPXnZqb+Vub8msVF38y1mt1mJ8PsZ
Sl6I9+jT1gOT2ar57tPRxlLN7KOlFFFOvWkihMNfKGEoeiWExEKN+Zu6XrKG9ynFsJcGsY5a
8odzfZrg28UwlcwU0PFwuZvEXxPg8Wl5tTK9TZgkk8Z8GxTqVRM1tXuURcuZuI08w3mPN5ue
vnzTteYvOfK1lytaxm+kHGomZwTFE1CaVmDMz0dzlOtqxBes4GcPVSlC0sYzuZzph1kZEjXP
OpjjFeT4w1kNDN6quC25mXBj4nLLj1SdvKz0bGhOHo9GucrxaXGHFuFjEiW5mHyKqpTEqmoS
RSSJWeT5qfjL2vlY+c5usc+Tu5zOb1Ge9nd+H0WlLMbJ92mJWtKVlnlfR0etD4+VVp0pnDzy
q2J+DLd6zTDbdwe6zvVVeMujRxtOqmfRc6WJ5TrTwejbetDYpbXixjFcY8uZ3N8DNM4Y5zdD
cGm2XjuofQmYTKZmEO3mvnnt1xWL1fmfM83jp05GUyw3KYjF4SlNRbCUpO22qRNXfLTFRvE8
FNeymWLzM+HTwpSUqLZzS2kpzsXFxSRbg0Mtq1Cfg802Hukpkepbe7nSfU1wckwl8iJlEzEk
PsMNomb1lZdVjOj2eiiMshqBnlIiWEQmyCCIheGFKVU2wlKYeywWSSeqsjQMrzKlgGAYRwJI
IGBsCgwEveJs0JFXyww0tScRoebGOspGvJ648Fy1S2xh11hzhZJJS2XNDx1rjI1zLwSwN6b1
M2NkxK4ODv0DwP3mRDicz3nKxi+4rGb8+XvG4rjmM3KUzJKUzMw5yvlXd6ZrVRapTxn2lBhV
iWuc7NWh480nneTV8GUMsLS2wM3c1jonSWtJ0/Muh7lv1mCuUt0UNaTK/XPSx4PBxke94qr3
V5lNyuCmYBIB+ABjE54wk0aWGisO7rWI0LHNKoTuE7tzSDg7eWkVmxD1XlbmYdzIvayzk69M
VVTWbtXu7tXePNeTuUzqnI05hsK27KJ1zo05t63F7d7m0SpenFtpMFqDb2aunCmUZi3Na8Yv
GtilgwOMauNlKTkXQesZVVsKS3BsjcyFN7CgUoVFKYym8c1vet/wBxTDCVKS0pxlbC2G2XW2
WmWmWnjbx1txtxtxtxpxp1xhxhtxhxhxhxh1xtxxTamlOKcU4p1ltptKlJbU0ythbDbLbbLT
LTLTrbrrbjbjbjbjTjTrjDjDbjDjDjDjDrjbjim1NKcU4pxx7HofaD0DEBAfmB+QHofl9Znp
w/gP1hEI/iJB0g0DwGPrPAP5g/gGzeoGIetA4D5Ax5Bm3oCTDPYD7wP3gkDx6DIQcBKD8IfW
fwmrcm45w5F9M+rrm5du3JxbsrxeLvLnic65nfEOTas5W1MqlKeNCUoicQUpRMxNUwXilLxS
1zFVSY4CAiiQIBDRiAmoEItMMJcCWobBBWVS7P+gg+4CH7B+ZQOgoH4AegPQGfAnvB9AP9H/
Ax8WPxH9j2Ax/QHqB8ge8GP2A+4H0g+8GPeD0P+gx/59jb8/32tEfy/9+A+h94H4H3A/IH4v
sP5BCI/5OA+oMgfcB4D9QQfqQfigQ/+Bs0D7wQbBB+4GCD8wPyP0ggyD8QSCDJ+gFAg6B/MD
YOAg+gP5knDHQY+sH0AxwGPsG/+LuSKcKEhXXBlnAA==
--------------060202070005020606050501--
