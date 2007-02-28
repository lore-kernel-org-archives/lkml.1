Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXB1B1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXB1B1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXB1B1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:27:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:51670 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbXB1B1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=OxJkkgmdr7JLDnprrgUnVfoAKqJ+hAHEBs0lg230DK2CIg6yHbvLmARV12SluJhxN9UbLY1jDfEy8PL1/GyZ0F36rUAqK/f3NAOknkTYdTH4vt+6gYxnj5MGh5BfmEIHqgZU+/HuzivGVFxnIVLNdGb2E8QFlJMWW/CDOWYnKiY=
Message-ID: <29495f1d0702271727w358cc9o644c4017d50634a9@mail.gmail.com>
Date: Tue, 27 Feb 2007 17:27:07 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: SMP performance degradation with sysbench
Cc: "Rik van Riel" <riel@redhat.com>,
       "Lorenzo Allegrucci" <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <45E2E244.8040009@yahoo.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_18904_16932382.1172626027049"
References: <1172425476.5489.11.camel@odyssey.lan>
	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_18904_16932382.1172626027049
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 2/26/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Rik van Riel wrote:
> > Lorenzo Allegrucci wrote:
> >
> >> Hi lkml,
> >>
> >> according to the test below (sysbench) Linux seems to have scalability
> >> problems beyond 8 client threads:
> >> http://jeffr-tech.livejournal.com/6268.html#cutid1
> >> http://jeffr-tech.livejournal.com/5705.html
> >> Hardware is an 8-core amd64 system and jeffr seems willing to try more
> >> Linux versions on that machine.
> >> Anyway, is there anyone who can reproduce this?
> >
> >
> > I have reproduced it on a quad core test system.
> >
> > With 4 threads (on 4 cores) I get a high throughput, with
> > approximately 58% user time and 42% system time.
> >
> > With 8 threads (on 4 cores) I get way lower throughput,
> > with 37% user time, 29% system time 35% idle time!
> >
> > The maximum time taken per query also increases from
> > 0.0096s to 0.5273s. Ouch!
> >
> > I don't know if this is MySQL, glibc or Linux kernel,
> > but something strange is going on...
>
> Like you, I'm also seeing idle time start going up as threads increase.
>
> I initially thought this was a problem with the multiprocessor scheduler,
> because the pattern is exactly like some artificat in the load balancing.
>
> However, after looking at the stats, and testing a couple of things, I
> think it may not be after all.
>
> I've reproduced this on a 8-socket/16-way dual core Opteron. So far what
> I am seeing is that MySQL is having trouble putting enough load into the
> scheduler.

Here are some graphs from the 4-socket/8-way Xeon box (no SMT, no MC
in .config) I posted about earlier.

transactions.png resembles Nick's results pretty closely, in that a
drop-off occurs, at the same # of threads, too. That seems weird to
me, but I haven't thought about it too closely. Shouldn't Nick's be
dropping off closer to 16 threads (that would be 1 per core, then,
right?)

idle.png is the average % idle according to sar over each run from 1
to 32 threads. This appears to confirm what Rik was seeing.

Not sure if my data is hurting or helping, but this box remains
available for further tests.

Thanks,
Nish

------=_Part_18904_16932382.1172626027049
Content-Type: image/png; name="transactions.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="transactions.png"
X-Attachment-Id: f_eyp36ilf

iVBORw0KGgoAAAANSUhEUgAAAoAAAAHgCAMAAAACDyzWAAABKVBMVEX///8AAACgoKD/AAAAwAAA
gP/AAP8A7u7AQADu7gAgIMD/wCAAgECggP+AQAD/gP8AwGAAwMAAYIDAYIAAgABA/4AwYICAYABA
QEBAgAAAAICAYBCAYGCAYIAAAMAAAP8AYADjsMBAwIBgoMBgwABgwKCAAACAAIBgIIBgYGAgICAg
QEAgQIBggCBggGBggICAgEAggCCAgICgoKCg0ODAICAAgIDAYACAwODAYMDAgADAgGD/QAD/QECA
wP//gGD/gIDAoADAwMDA/8D/AAD/AP//gKDAwKD/YGAA/wD/gAD/oACA4OCg4OCg/yDAAADAAMCg
ICCgIP+AIACAICCAQCCAQICAYMCAYP+AgADAwAD/gED/oED/oGD/oHD/wMD//wD//4D//8BUJrxz
AAANj0lEQVR4nO3diZaizBJFYVi+/zt3l4oyqUBG5onI2N+63fxdQ4qwL8hg1TAAAAAAAAAAAABk
No6Pv+/T5QSobiru/mc5Aap71DblRoBo7rXPneIbp8nrC4DfCgNc1zcLsCzwzeM5Hi3VcF5m7udr
QC8z2mC0VMN5mTkCTDqcj5mbdt/PnfhyUjTyx0d0PFqq4VzPXJuR0REChBQBYmN5dmT3X6sTKN/O
pty+P9alOTyCAKNaHUzu/Wt1zeHr6TwCxDnb5DafW5/wIEDYWl3RWn9uedFrWentl+Vgdea/6sio
bXE6bXWFfzr9NnwKcI0t4I7vCyW7zfHFqse9Kj+PRoA7CPCLV03zq13zv9YfJMDTCPCLb5e5dj9X
cltLlgDnxe29FsaO7QHwjy+58hiF368Y+Yopt2d6t4EAfUgU4Hyz9zclQQ9SBLjd596eH9fMD956
DfCd1rTP3f+yZ4OUqNJ3gO/t3ufC7l+x/jRBttJvgMud7rei/n8dAap0GeDJ8yw7lykJsJUuAxxO
1Pf8hvc37l8zRyVdBvj5oOPLdyz/TX6N9Bjg3lHFgW9Z/psC2+gvQJON1/ltKK7pLkC7btgNt9Bb
gKbRUGB9fQVovdGiwOq6CtC+FwqsrZcALxz5Hh4XFfUTYKVjBgqsK2qA7c4cU2BVPQRY+drZl7u5
UCxygPPwqhbCdZF6Qga4s8WrWwjnpKsJGeDQ9g5S7o6pKGiArXOgv1oI8NjjsRuuJGqANQf/9Hgk
WAEBnnpYErQWM0BdBw1O+uRCgKcfm/PSlgjwwqOzJ7YTMkB5f21Pg3eNAC/OAG8jtkGAJTMwbQvl
MxQXARbPAFfqSkQM0N+6Jr/LCNAC92tdRoAWeBl4WcAAna5qdsOXEKAdtzPmGQEa8jtnfhGgJcez
5lW8AF2vZNcz5xIB2vI9dw5dzmTxG+32fo97zgC9z547VzN5pTb95tidX6NdhfsVzLXhUy7/jsPX
7+kkwDWui5xQuAuefnv7tCGc7YMLfoXnNxHWLeekjylKZP7LjMdFhNMXmMzjhv91y90xZ5QG2HoX
HGO9kt9hJkfBBLhCgIddPQh5777bnoaJsWY5DDks2onoKCs2ynzKBQswznqNM6daBFhLoFlVIsBa
As2qUqwAQ63UUDMrQ4D1xJpbEQKsJ9bcihBgRcFmVyJUgNFWaLT5VSDAmsLNcHsEWFW8OW4tUoAB
12bAWW6MAOuKOM9NEWBdEee5KQKsLORMNxQowKCrMuhst0KAtQWd7VYIsLqo891GnADjrse4c94A
AdbHO0S+CBNg5DeaRZ732giwgcjzXlucAG2Ha4iflPBNjACjr8PI815ZjACHyFvAgV/j8AUBtvA3
82wEdxFgOx08BXtRAuxi5bER3CLApjp5GoYIsK37RrCXJ2OBAFvjiHiBAJvjpOAcAbYW/aS6sSAB
9rW+yO+NAAVuJPhCgAIcCb8RoEqHT+kKApRhN/yHAIX6fFbnxAiw1zXV6/M6gQCl2A0ToFj2I2IC
VEt+bZgA5XJflyNAteTXhkME2PvayZsfAbqQ+Wd3EKADmY9DCNCJDM9xDwF6keJJbhGgGzme5VqE
ALOsmSzPc4EAHcl4OuZyJuP4+Ps+XU4KR95ItFoSPdWnq5lMxd3/LCeFI29lWiuZnuvdxUwetRGg
vVRPdijeBQ9TeeN78vr4fIdcItc6SXRWuiiR53eOj83ePMLpCwzm8C7L6pjkujBXfBAy/V1vF5xp
ddylOhguC/C1GSRAM8luz7p6EPLYfT8ndU/DpFkXL3nyC3EiOtHaeMr0ozsI0KFMb1TyH2CWNbGW
5HkToFs5njgB+pXimROgYx8ORbpaIgTo2u6T72qJEKBve8++qyXiPsCulvYF61MyvV0oIUDvbu+b
E57pdZQfAUbwiO692evqQgkBerfd53Z1oYQAA+j5SIQAA9g/GdPHkiHAAD4sgy4WjfcAu1jItfSw
cAgwsg52wwQYW/gjYgIMLvq7OAkwuuDX5QgwuOjXhp0HGHfBNhQ4PwLsQegfpUCA8YU+DiHAPoRd
UATYiahLigB7EXRR+Q4w6ELViLmwCLAfIZcWAXbk2OLytVAJsCeHlpevhUqAXTmywHwtVALsy68l
5u7SsesAHS2nML5fFvlrz1N+BNif7ZXh2fva979AiQC7s9nCPbKbva/d04IlwM7c3l4f2t606mfJ
EmB/Fj9K5sNRh5tFS4D9+fQa8PcHBTwH6GUZRXMoQC9LlwD75/oHKxBgXi6WLwEm5mEBE2BmDpYw
AaamX8SOA9QvnATkl0UIMDn1lWECzE58cwwB5nbg/sC664EA09u5V2H1+ZoIML3V3VoHr+RZ8Rsg
/TUyv3lm/u/pY3Vv4SdAzNyevxhsHl7do5TLmYzj4+/7dDkpHPmJABV2tnh1T9RczWQq7v5nOSkc
eUKAIjuvAf3tgh+1EWCPTv5isML1VLYLvlc3riavL5jvkM8jQJGTN1AXrKeiRKYXfdsIpy+4PmN/
6M+Xj+tDvQWstQsmQGf2N4zFZ2kIEAftvjYs/kELVw9CnrvvSqdh3P0EEww7Bd5uQ/FpQq8noqnP
oeU6ea6iwtOEBIjjZitlvoIkrwHrjqy+TRL7ppPSq+1DyamYovmpNjL5OXXfMuz/+KNrfAZIf27t
HxxeX2EuA6Q/rz6enri8yggQ5xj/oA+PAdKfZwQIqU9r5+Jacxgg/cV0bb35C5D+giJAaF1ac+4C
pL+4rqw7AoSdCyvPW4D0FxkBQuv86nMWIP0Fd/o2pl+ZjMNw8Z1LV76J/sI7eyPnj0we73W7VCAB
pmQd4OMrGgVIf9GdfzMPAcKW9S54+V5Lu5F30F8PrA9Crm4Az38T/XXBOMDrTo7M25ByOrQFrDLy
Cu/DzOnQa8AaI68RYE7HjoIrjLzAj+JIy0eAA4cgWR3YBbe5EkKAOXkJkP1vUl5Ow9BfUr9fA1Ya
eYUAkyJASDl5DUh/WREgpJzsggkwKwKElJPTMASYlY8A6S8tAoQUAUKKACFFgJByESD95UWAkCJA
SBEgpDwESH+JESCkCBBSBAgpAoSUgwDpL7PCAJ+36y8nJ0cmwMzKAnz+9Mrl5OzIBJgZAULKZBf8
+Fn602T2qUOjE2BWV99wOR9hXd/5LSD9pabfBRNgagQIKf1pGAJMTX4imv5yI0BIESCkCBBSBAgp
dYD0lxwBQooAIUWAkBIHSH/ZESCkCBBSBAgpAoSUNkD6S48AIUWAkCJASBEgpKQB0h8IEFIECCkC
hJQyQPoDAUKLACFFgJAiQEgJA6Q/ECDECBBSBAgpAoSULkD6w0CAECNASMkCvBEgBmWA1R4YkRAg
pDQB3h6qPTbCYAsIKQKElCpA9r+4kwVY7XERCgFCigAhRYCQIkBIiQKkPzwQIKQIEFIECCkChFRh
gON/m8mBkQkQD2UB/vX2/89ycmBk+sNTeYDDusMDIxMgnkoDHF/xjdNk+bldBIjheyJHR1jXxxYQ
p/AaEFIECCnJaRj6w0RyIpoAMSFASBEgpAgQUgQIKUWA9IcXAoQUAUKKACFFgJAiQEgJAqQ/vBEg
pAgQUgQIKQKEFAFCqn2A9IcZAoQUAUKKACFFgJAiQEg1D5D+MEeAkCJASBEgpAgQUgQIqdYB0h8W
CBBSBAgpAoQUAUKKACHVOED6wxIBQooAIUWAkCJASBEgpNoGSH9YIUBIESCkCBBSBAgpAoRU0wDp
D2sECCkChBQBQooAIUWAkCoPcBz//vz9PU0+jUx/2CgO8K+5R4PT5OPIBIiN0gBHAkSJwgAf2d3/
95q8PjXfIf8hQCxsEzk/wrCqjy0gTikNkF0wipgcBR8LkP6w1fA0DAFiq+GJaALEFgFCigAhRYCQ
ahcg/WEHAUKKACHVKMDbQ7UHQ1RsASFFgJAiQEi1/43pwAwBQooAIUWAkCJASBEgpAgQUgQIKQKE
FAFCigAhRYCQIkBIESCkCBBSBAgpAoQUAUKKACFFgJAiQEgRIKQIEFIECCkChBQBQooAIUWAkCJA
SBEgpAgQUgQIKQKEFAFCigAhRYCQIkBIESCkCBBSBAgpAoRUmABth3M9c76H8zVz43+bicnIm0dy
PFqq4VzN3F9v//8sJyYjbx/K8WiphnM1cwSYbzh3M/cob3xPXh8HfivObxzm9RUPCJzw6G13FwxU
98yNAKEx7cWf+3KDXToAAAAAACHZHhObnDZ/DzYNaTec2Qwan1J4n6ewGM/1zK3HNj0raBzzYDiD
7+EsGJ9UnQ1nwPXM7Q9uN5zZ/0nGwTTA13BWG8A669hu8dlecrCduc3AlsPZ9TwFaLYjGWxncHNn
h8VwRj2/iy4f7T1cha1ghVsTrAO0msHXKGYvjGznbpz+w2I469tOZpdzbVXI2nwL6DLAxQ0eVsMt
/6t0QOOt/WxiqMJBiOsALV+0uR2u3kFIlReBpoNavope3ELBcCeHG+xWBnexAAAAAAAAAAAA4Khx
+9N2fl1l4ioU7CwCfN/X8vVbCBBWlvf2EiAaWwQ4uw/lPRm2E7t7VZDeh13w+6a32b1vux8ECnza
Bb9vYR8XG8R674hASkcCHFYfPPZKEThivQte7maHDztkNoIwsjwPOH/T4RTY9uiDgxAAAODCP1Zb
G+upwDpBAAAAAElFTkSuQmCC
------=_Part_18904_16932382.1172626027049
Content-Type: image/png; name="idle.png"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="idle.png"
X-Attachment-Id: f_eyp36wee

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
------=_Part_18904_16932382.1172626027049--
