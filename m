Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbXGBPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbXGBPsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXGBPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:48:04 -0400
Received: from xenotime.net ([66.160.160.81]:57751 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752856AbXGBPsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:48:03 -0400
Date: Mon, 2 Jul 2007 08:50:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: ltp-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ltp-announce@lists.sourceforge.net
Subject: Re: [LTP] [ANNOUNCE] The Linux Test Project has been Released for
 June 2007,
Message-Id: <20070702085054.0efb79ff.rdunlap@xenotime.net>
In-Reply-To: <4688A22A.2090907@linux.vnet.ibm.com>
References: <4688A22A.2090907@linux.vnet.ibm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Mon__2_Jul_2007_08_50_54_-0700_w_O4Cm.eJmw2z1U="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Mon__2_Jul_2007_08_50_54_-0700_w_O4Cm.eJmw2z1U=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 02 Jul 2007 12:28:50 +0530 Subrata Modak wrote:

>   :-) *Dear All*,
>  
> *Note(s) from the Maintainer: *
> * We have seen that the LTP mailing lists has become active for the last 
> couple of months. Thanks to all who has made this happen. We as an 
> integrated team can work hard to make this Project a resounding success. 
> Following are the different milestones/activities that we aim to 
> perform/achieve in the coming months:
> 1) Investigation into LTP Log(s) Library to make this more meaningful 
> and parsible. Kindly provide your inputs for the output that LTP 
> generates now and whether/how you would like it to be in future

I don't know if this qualifies as an input for the output, but
I use a script to parse the results file to compute a gross/overall
"SCORE" value.  Instead of looking at lines that contain
"termination_id" (e.g.:
duration=0 termination_type=exited termination_id=0 corefile=no
), I look at the test results output format messages and count
them (ignoring the INFO lines) and then compute a SCORE based on
all of those lines.  Obviously that's why I've been changing several
test cases to use the standard test results output format.

ltprun-summary.sh is attached.  It uses prtag2tag.pl, which is also
attached.  (I also do this summary SCORE for the Open Posix Test suite.)

Example summary + SCORE:

Using logfile=/cruc/runs/1789/test_output/ltp.log
build errors:  0 lines
PASS:          2225
WARNing:       1
BROKen:        1
RETiRed:       0
FAIL:          0
CONFig error:  11
SCORE.ltp:        99.5


> *Please also see the ChangeLog Below (June 2007):* *

so "[PATCH] float tests: use standard test results output"
(http://sourceforge.net/mailarchive/forum.php?thread_name=20070622214652.d137d055.rdunlap%40xenotime.net&forum_name=ltp-list)
will be added next month?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--Multipart=_Mon__2_Jul_2007_08_50_54_-0700_w_O4Cm.eJmw2z1U=
Content-Type: application/x-shellscript;
 name="ltprun-summary.sh"
Content-Disposition: attachment;
 filename="ltprun-summary.sh"
Content-Transfer-Encoding: base64

IyEgL2Jpbi9zaAojIHN1bW1hcnkgb2YgTFRQIHN1aXRlICdsb2dmaWxlJyByZXN1bHRzOgojIGNv
dW50ICJleGVjdXRpb246IFBBU1N8RkFJTHxXQVJOfEJST0t8UkVUUnxDT05GKGNvbmZpZyBlcnJv
cikiOwojIGNvdW50ICJcLmM6LiplcnJvcjoiIGZvciBidWlsZCBlcnJvcnMgKGxpbmVzKTsKCmxv
Z2ZpbGU9JHsxLWxvZ2ZpbGV9CmVjaG8gIlVzaW5nIGxvZ2ZpbGU9JGxvZ2ZpbGUiCgpUTVBGSUxF
PSIkbG9nZmlsZS4kJCIKcHJ0YWcydGFnLnBsIHRlc3Rfb3V0cHV0IGV4ZWN1dGlvbl9zdGF0dXMg
JGxvZ2ZpbGUgPiRUTVBGSUxFCgojI2J1aWxkX2ZhaWxlZD1gZ3JlcCAiYnVpbGQ6IEZBSUxFRCIg
JFRNUEZJTEUgfCB3YyAtbGAKYnVpbGRfZXJyb3JzPWBncmVwICJcLmM6LiplcnJvcjoiICAkVE1Q
RklMRSB8IHdjIC1sYAoKcnVuX3Bhc3NlZD1gZ3JlcCAiXlx3KiAqW1s6ZGlnaXQ6XV0qICpQQVNT
ICo6IiAgJFRNUEZJTEUgfCB3YyAtbGAKcnVuX3dhcm5lZD1gZ3JlcCAiXlx3KiAqW1s6ZGlnaXQ6
XV0qICpXQVJOICo6IiAgJFRNUEZJTEUgfCB3YyAtbGAKcnVuX2Jyb2tlbj1gZ3JlcCAiXlx3KiAq
W1s6ZGlnaXQ6XV0qICpCUk9LICo6IiAgJFRNUEZJTEUgfCB3YyAtbGAKcnVuX2ZhaWxlZD1gZ3Jl
cCAiXlx3KiAqW1s6ZGlnaXQ6XV0qICpGQUlMICo6IiAgJFRNUEZJTEUgfCB3YyAtbGAKcnVuX3Jl
dGlyZT1gZ3JlcCAiXlx3KiAqW1s6ZGlnaXQ6XV0qICpSRVRSICo6IiAgJFRNUEZJTEUgfCB3YyAt
bGAKcnVuX2NmZ2Vycj1gZ3JlcCAiXlx3KiAqW1s6ZGlnaXQ6XV0qICpDT05GICo6IiAgJFRNUEZJ
TEUgfCB3YyAtbGAKIyBpZ25vcmUgSU5GTyBsaW5lcwoKcHJpbnRmICJidWlsZCBlcnJvcnM6ICAl
cyBsaW5lc1xuIiAkYnVpbGRfZXJyb3JzCnByaW50ZiAiUEFTUzogICAgICAgICAgJXNcbiIgJHJ1
bl9wYXNzZWQKcHJpbnRmICJXQVJOaW5nOiAgICAgICAlc1xuIiAkcnVuX3dhcm5lZApwcmludGYg
IkJST0tlbjogICAgICAgICVzXG4iICRydW5fYnJva2VuCnByaW50ZiAiUkVUaVJlZDogICAgICAg
JXNcbiIgJHJ1bl9yZXRpcmUJIyMgTkI6IG5vdCBjb3VudGVkIGluIGFueSB0b3RhbHMKcHJpbnRm
ICJGQUlMOiAgICAgICAgICAlc1xuIiAkcnVuX2ZhaWxlZApwcmludGYgIkNPTkZpZyBlcnJvcjog
ICVzXG4iICRydW5fY2ZnZXJyCgpwYXNzaW5nPSQoKHJ1bl9wYXNzZWQgKyBydW5fd2FybmVkKSkK
bm90cGFzcz0kKChydW5fYnJva2VuICsgcnVuX2NmZ2VyciArIHJ1bl9mYWlsZWQpKQp0b3RhbD0k
KChub3RwYXNzICsgcGFzc2luZykpCnNjb3JlPSQoKDEwMDAgKiBwYXNzaW5nKSkJIyBjb252ZXJ0
IHRvIHBlcmNlbnQuZGVjaW1hbApzY29yZT0kKChzY29yZSArIHRvdGFsIC8gMikpCSMgcm91bmRp
bmcKaWYgWyAkdG90YWwgLWVxIDAgXTsgdGhlbgoJc2NvcmU9MAplbHNlCglzY29yZT0kKChzY29y
ZSAvIHRvdGFsKSkKZmkKZnJhY3Rpb249JCgoc2NvcmUgJSAxMCkpCnNjb3JlPSQoKHNjb3JlIC8g
MTApKQpwcmludGYgIlNDT1JFLmx0cDogICAgICAgICVkLiVkXG4iICRzY29yZSAkZnJhY3Rpb24K
cm0gLWYgJFRNUEZJTEUK

--Multipart=_Mon__2_Jul_2007_08_50_54_-0700_w_O4Cm.eJmw2z1U=
Content-Type: application/x-perl;
 name="prtag2tag.pl"
Content-Disposition: attachment;
 filename="prtag2tag.pl"
Content-Transfer-Encoding: base64

IyEgL3Vzci9iaW4vcGVybAojIHBydGFnMnRhZy5wbDogcHJpbnQgbGluZXMgZnJvbSBpbnB1dF9m
aWxlIGZyb20gL1RBRzEvIHRocnUgL1RBRzIvIChvciBFT0YpCiMgKEMpIENvcHlyaWdodCAyMDA3
LCBSYW5keSBEdW5sYXAKIwojIFRCRDogaG93dG8gaGFuZGxlIHN0ZGluIHZzLiBmaWxlbmFtZT8K
IyBUQkQ6IGFkZCBpZ25vcmVjYXNlIG9wdGlvbjsKCnN1YiB1c2FnZSgpIHsKCXByaW50ICJ1c2Fn
ZTogcHJ0YWcydGFnIGJlZ2luX3RhZyBlbmRfdGFnIGZpbGUocylcbiI7CglleGl0ICgxKTsKfQoK
bXkgJHByaW50aW5nID0gMDsKbXkgJGJlZ2luX3RhZyA9IHNoaWZ0IChAQVJHVikgfHwgdXNhZ2Uo
KTsKbXkgJGVuZF90YWcgPSBzaGlmdCAoQEFSR1YpIHx8IHVzYWdlKCk7CgppZiAoJGJlZ2luX3Rh
ZyBlcSAiIiB8fCAkZW5kX3RhZyBlcSAiIikgewoJdXNhZ2UoKTsKfQoKZm9yZWFjaCBteSAkZmls
ZSAoQEFSR1YpIHsKCglvcGVuIChGSUxFLCAkZmlsZSkgfHwgZGllICJDYW5ub3Qgb3BlbiBmaWxl
OiAkZmlsZVxuIjsKCglMSU5FOiB3aGlsZSAoJGxpbmUgPSA8RklMRT4pIHsKCQljaG9tcCAkbGlu
ZTsKCgkJaWYgKCRsaW5lID1+IC8kYmVnaW5fdGFnLykgewoJCQkkcHJpbnRpbmcgPSAxOwoJCX0K
CgkJaWYgKCRwcmludGluZykgewoJCQlwcmludCAiJGxpbmVcbiI7CgkJfQoKCQlpZiAoJGxpbmUg
PX4gLyRlbmRfdGFnLykgewoJCQkkcHJpbnRpbmcgPSAwOwoJCX0KCX0KCgljbG9zZSAoRklMRSk7
Cn0K

--Multipart=_Mon__2_Jul_2007_08_50_54_-0700_w_O4Cm.eJmw2z1U=--
