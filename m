Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbZLFTdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbZLFTdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZLFTds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:33:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:43675 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZLFTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:33:46 -0500
Date: Sun, 6 Dec 2009 11:35:55 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091206113555.5a646713@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
References: <200912052216.19540.rjw@sisk.pl>
	<200912060055.36130.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051635330.3560@localhost.localdomain>
	<200912060254.10081.rjw@sisk.pl>
	<alpine.LFD.2.00.0912051758190.3560@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Z3T4fpKJS1mast=qfqs523h"
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Z3T4fpKJS1mast=qfqs523h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sat, 5 Dec 2009 18:05:14 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 6 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > While the current settings are probably unsafe (like enabling PCI
> > devices to be suspended asynchronously by default if there are not
> > any direct dependences between them), there are provisions to make
> > eveything safe, if we have enough information (which also is needed
> > to put the required logic into the drivers).
> 
> I disagree.
> 
> Think of a situation that we already handle pretty poorly: USB mass 
> storage devices over a suspend/resume.
> 
> > The device tree represents a good deal of the dependences
> > between devices and the other dependences may be represented as PM
> > links enforcing specific ordering of the PM callbacks.
> 
> The device tree means nothing at all, because it may need to be
> entirely rebuilt at resume time. 


btw I instrumented both the suspend and resume, and made graphs out of
it for my laptop (modern laptop with Intel cpu/wifi/graphics of course).

http://www.fenrus.org/graphs/suspend.svg
http://www.fenrus.org/graphs/resume.svg

(also attached for convenience)

the resume clearly shows that all this talking about PCI stuff is
completely without practical merit.. it's the USB stuff where the time
is spent.

in suspend, there's a PCI device (:1b) that does take some time, which
is the audio controller. The bulk of the time is in the serio driver
though..


As an "interested bystander" to this thread.... sounds like Linus'
arguments have merit, and that solving the USB resume to go async in
some form will fix pretty much all we want solving...

[and that at least we need to do this stuff data/measurement driven,
and not just based on how we THINK things work]





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

--MP_/Z3T4fpKJS1mast=qfqs523h
Content-Type: image/svg+xml-compressed
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=suspend.svgz

H4sICJEFHEsAA3N1c3BlbmQuc3ZnAM1c/25TORP9n6eoIq20SPTWY3vG4y5lH+VTgQDVdpsqDQvs
03/HN2yvL7lubYillPKrbSbnjD0zZzxOXv/59e/bs3/W24ebzd3VigazOnvYXd+9v77d3K2vVneb
1Z9vzl68fvjn49mXm/e7T1crawx+6NP65uOnHR5hzG+r3ACtzmDy7uFq9Wm3u7+8uPjy5cvwxQ2b
7ceL9NALmFq9efF6u363O/t6tYKt74bNYFwUQ+p88MazyursG0xy/nSeE8Bvt8D24eb29nL78e3v
5pV5ZZlf/pG+cr65v353s/t2aQb+42G33fy1Ph+fAF+g7194fJR5uboAlt366+5st72+e/iw2f59
tRr/eXu9W/9Or4j9y7PtZpf+F/HzZx82d7vzh5t/1wkx3e9Wb27u7j/vwuuLZCZnNhgfANh4ciDj
OT5StX4gb8hLDOJDrOYJlsDcgafMsfIB7Tfh3B4wBA3rgIksB/YTOzuINRSNekfOVrIbub2yXeg5
kwM9JCfndEguxAEb1gel9NiMnhmwQ0OM6mMgaeE3/u7C0CrP0B5ytOf+kGOMgzAHUZFghfJYxMoZ
I0SsaaO2LWKfYHTGzNBWx6YsEg/wVoxMxgb5ZeL72OxIPEdbTZyXiauxjuBH76ddrUxDZCEWFkvM
1bzJaj/ePAN7uKkf1tubzWHsYvFoCEwoJAh6nVhS1IFUnfXKotE3rS6YdqkxYJeDLbA0hyydj1gz
r8pqKYZHlmHwCmsShNWLrWW5D95eLB2bHOyTe9iNO1iNP6w5sAN64BWNGO/yyCXrwTaaCAlB1Wv7
X17ux1tzvDWx+/nh7aGcGImLcdAMzlHwecqCeY6IYKsocEEbmHeM3pF5BriS+WGy3jNXrCzUJlmb
Mzeo58jXIqQWmatWSn2n3Zf6hLiS+mG6HqkHIuQsY+HLGXWk6iSUo1CMUM4noJYT7QxtJe1DXbKn
jT+M8z6Xlj+/4h3F8572hLaStivQRvk1yN0m5KxDQAipBEXlctSW0fsozj3rR7CVpAsJXdH3iTiG
rjvCFu8rtUfiGeBK5gsqJRkyHl2ER8nSwi4nCaS1cqyr/gbemOOtIZ6ky/UtytKSfEn0JWltB6rh
aEHelf6Et1qFL+W31FyKN9Cpzv6w8tGjbhjwDg3dZVcdTk5NDrea+VKKS8xDJNjyUlp0gtj3tTKm
rzgfqU94q6kvJbpEPVpnbOpn+Gjh3pX6hLea+lKmA3V0c5y6V1g8wqp3l+0gnyGuJr+U5xJ5Fo+e
hFzMuaOe44NjepqmhqV3sE9wa4jfv3u4/2u7TJzRbQdnKLhQqOxBhE9Gt4N7hriG/Hb98TMevNl+
GwprL+hISdQxh8VEH7xDm1B/FtGxwIN+hraGvsHHpQmXJg6FOifWW5NOXJSO0r501PGJ/oS2kX6h
2EEkMila9FBIe2ocJP1JKPrEf4LbyL9Q8cQrKhpaBHeM5e8t7ZMHJsCNHigUPoFmdM6ng8wjaNzO
Ej85YMLb6IBSAgwhrXeEejya3uvqgAlvvQPk0piiAyKruJDE3TRGogHNvENr5BnF5kR0PudYD0+i
91RtgSoahIEdozsSiXHWyT/WOkJqqS73faW9NzaHW7/U5pI+LKX7xF+8Vesc/prSndpByZno1CPb
ce1a91X33oQcbGmtR64Lqd2rHzxW0zixMJCttWMENhom6Ga0TC1kuy42tnaGt3GxFzJ7coDaiB4h
IsTlSLW9Z3QnF2SIG12wFO/JBd6yEfbxh1PanyvvvfX96IIJcZML1kUXMLJ4Oh3ys10AVwe2wQZF
f1Nf3PrV9pH8hLWJ/PthYSKVyCOxe/bGBZvLO0KyCwIXR06l5AS0fSKfYW0kv5gAeTDY4xqQ1+fC
Zjwqs9aRoK2nRmHXi77kaBvpL6Y/0NeU4VnEzg6z4GSYt2CMCmtO437M3gET3kYHLEY+D0QxENIb
ZE3uAI9vBnGCvIcAOA1hn/hncJv4vxsWJpMjfxEV752fH+RmN2gsN3b2XflPcBv5FwKAlIPFdjcy
E7tEDt820JRIguYkrtLs+U9wG/kX9j+iW1BJhKf492gNorMBcQap791pKP1IGdYnpO7bJaaaXMcG
tZw1Wl2OdFiwbYc4vciqhhxu00pfL5X5xN/CHuIZpXOW6r1zwaGJxXdVQushTk8PZIAbPbAQ66MH
hIJG/Et10QNe8HkqZ/ijBybAjR4oxIAjTTvdIbKPcI7dW+onF2SIW1xgbGkToHSgnWEWJ4WEH7Xh
Pne/cj+yn8A2si9tACRPaKgQdF7u050+Q2iprGV3Cgf5I/sJbBP7xZOtMaem7iFC0Phj3EfqqvZV
NYdbe1FjQ/+7KXBHG4d2XuJ836OVCmhynDNJWDRdNO0o9Uf2E+Bq9qbIXhDfaOTHNv4oI4yega85
3qq5dbpoW+QeDLScTYcmRzji6qvxR+4T3rb7SUUHKGgSihzpUYYXfcu+5njrZ/dF8hHyhiN07tFG
t/1En2ZwWyf3JQega0B0RLKz6wsE5hZPZZPqa5zd9uSfoW2d3Zcc4FPbBBUZZuNrwh6L5NKY2GjT
hfPeWyDD2zq/L7kAnRSJDRGMj+KC3hkgw9s6wi+5QHwMLiKwZtpnvOgNlQXdB7VRO+npL/w1x9s6
wy+5IAT0emRpfo8h2wXBh/rbmn0FQIa1dYJfoq/R45Mo+uxlrOkKW3r5EgIO2rftrKeT9osuh1o6
6tkP65e4RhOGCOFk05Tgh2PNn+ryugr9aDRHW7/Y9mkHBGesT4PxXPRR0vohsmHHTVONjlp/dMCE
tnWGv+yA1Dyph67VH27p/tTV7L56P6ac9Yi2kf9ivh/5C5ba+6hGf90BfUX/6IAJbutgv+iBkEZ3
bsYfcQ/NqwQ/WHci5/oj/f+wto70S+Q9HIqCZimv9mjwOR0pIPYjnvAkRH9iP4FtHeeX6ItPr7KC
S7M7TKnWoaJCWjGjWzyNG/qRfA72icHG+yEssrVgy+pSRKvXQrL31dfTeiv8aGOOt3WKX3KBopcT
ax16ukUXeGuqLzH0VvjJBRne1kn+sgtiOtAA4qie7cwFzke01JagMbRW4PVW+Eh1Od7WWX7JBekA
1zE7dcuyDwnWxPqTro41H/wzsK2z/CL/iMgS8jFygT8rtd3S7ST6Ev8JbOssv8TfmmicBCF2v77+
fWV/ekObCW3rML/oAHy4gF9Ev74Begt/Z3K8TS54+4QLUO1cQFqRWZsLsRsj0loQ07gBuqUAzrE+
UfmvC5Xfx3RWZqHmA3P85bLXWeSzydG2TvRLDuAQOA0/5iO9rOiRP5FX4CYHZGhbB/olB4Bk5BjV
2dnrErN3G5CGF6Z1VX5wQIa2dZxfcgBskThhG2Y1H9y9pGhH1PvGt1vo6YEMbutIv+SBaK2kK8F2
Pt/6qS3QXf6n9xCa8LbO9TMXlJ/EvNL4wzunoSz4ikcSfjBmH0uGHFUYsjwzpIuGtMKQ05mhsGTI
c4Uh9Py5IVkyxLbCkPgKQ7HCUAgzQ7xkSKTCUDpCyAz5JUPB1Sy/cTNLi4ZqqBHJs4a0hhqld3t7
xlCsoubt04acqbHC/JwV5J0aQ6LPGqKqiFV61pCtidh9Jn3G0BSx6U1Q37z4PyLlxbR9VQAA

--MP_/Z3T4fpKJS1mast=qfqs523h
Content-Type: image/svg+xml-compressed
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=resume.svgz

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
AAA=

--MP_/Z3T4fpKJS1mast=qfqs523h--
