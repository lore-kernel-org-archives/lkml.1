Return-Path: <linux-kernel-owner+w=401wt.eu-S932558AbZHMUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbZHMUzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZHMUzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:55:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZHMUzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:55:16 -0400
Message-ID: <4A847E30.9050903@redhat.com>
Date: Thu, 13 Aug 2009 16:57:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: [TOOL] kprobestest : Kprobe stress test tool
References: <20090813203403.31965.20973.stgit@localhost.localdomain>
In-Reply-To: <20090813203403.31965.20973.stgit@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------000702000009000002030102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000702000009000002030102
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

This script tests kprobes to probe on all symbols in the kernel and finds
symbols which must be blacklisted.


Usage
-----
   kprobestest [-s SYMLIST] [-b BLACKLIST] [-w WHITELIST]
      Run stress test. If SYMLIST file is specified, use it as
      an initial symbol list (This is useful for verifying white list
      after diagnosing all symbols).

   kprobestest cleanup
      Cleanup all lists


How to Work
-----------
This tool list up all symbols in the kernel via /proc/kallsyms, and sorts
it into groups (each of them including 64 symbols in default). And then,
it tests each group by using kprobe-tracer. If a kernel crash occurred,
that group is moved into 'failed' dir. If the group passed the test, this
script moves it into 'passed' dir and saves kprobe_profile into
'passed/profiles/'.
After testing all groups, all 'failed' groups are merged and sorted into
smaller groups (divided by 4, in default). And those are tested again.
This loop will be repeated until all group has just 1 symbol.

Finally, the script sorts all 'passed' symbols into 'tested', 'untested',
and 'missed' based on profiles.


Note
----
  - This script just gives us some clues to the blacklisted functions.
    In some cases, a combination of probe points will cause a problem, but
    each of them doesn't cause the problem alone.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


--------------000702000009000002030102
Content-Type: text/plain;
 name="kprobestest"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="kprobestest"

IyEvYmluL2Jhc2gKIwojICBrcHJvYmVzdGVzdDogS3Byb2JlcyBzdHJlc3MgdGVzdCB0b29s
CiMgIFdyaXR0ZW4gYnkgTWFzYW1pIEhpcmFtYXRzdSA8bWhpcmFtYXRAcmVkaGF0LmNvbT4K
IwojICBVc2FnZToKIyAgICAgJCBrcHJvYmVzdGVzdCBbLXMgU1lNTElTVF0gWy1iIEJMQUNL
TElTVF0gWy13IFdISVRFTElTVF0KIyAgICAgICAgUnVuIHN0cmVzcyB0ZXN0LiBJZiBTWU1M
SVNUIGZpbGUgaXMgc3BlY2lmaWVkLCB1c2UgaXQgYXMgCiMgICAgICAgIGFuIGluaXRpYWwg
c3ltYm9sIGxpc3QgKFRoaXMgaXMgdXNlZnVsIGZvciB2ZXJpZnlpbmcgd2hpdGUgbGlzdAoj
ICAgICAgICBhZnRlciBkaWFnbm9zaW5nIGFsbCBzeW1ib2xzKS4KIwojICAgICAkIGtwcm9i
ZXN0ZXN0IGNsZWFudXAKIyAgICAgICAgQ2xlYW51cCBhbGwgbGlzdHMKCiMgQ29uZmlndXJh
dGlvbnMgCkRFQlVHRlM9L3N5cy9rZXJuZWwvZGVidWcKSU5JVE5SPTY0CkRJVj00ClNZTUZJ
TEU9c3ltcy5saXN0CkZBSUxGSUxFPWJsYWNrLmxpc3QKCmZ1bmN0aW9uIGRvX3Rlc3QgKCkg
ewogICMgRG8gc29tZSBiZW5jaG1hcmsKICBmb3IgaSBpbiB7MS4uNH0gOyBkbwogIHNsZWVw
IDAuNQogIGVjaG8gLW4gIi4iCiAgZG9uZQp9CgpmdW5jdGlvbiB1c2FnZSAoKSB7CiAgZWNo
byAiVXNhZ2U6IGtwcm9iZXN0ZXN0IFtjbGVhbnVwXSBbLXMgU1lNTElTVF0gWy1iIEJMQUNL
TElTVF0gWy13IFdISVRFTElTVF0iCiAgZXhpdCAwCn0KCmZ1bmN0aW9uIGNsZWFudXBfdGVz
dCAoKSB7CiAgZWNobyAiQ2xlYW51cCBhbGwgZmlsZXMiCiAgcm0gLXJmICRTWU1GSUxFIGZh
aWxlZCBwYXNzZWQgdGVzdGluZyB1bnNldAogIGV4aXQgMAp9CgoKIyBQYXJzZSBhcmd1bWVu
dHMKV0hJVEVMSVNUPQpCTEFDS0xJU1Q9ClNZTUxJU1Q9Cgp3aGlsZSBbICIkMSIgXTsgZG8K
ICBjYXNlICQxIGluCiAgICBjbGVhbnVwKQogICAgICBjbGVhbnVwX3Rlc3QKICAgICAgOzsK
ICAgIC1zKQogICAgICBTWU1MSVNUPSQyCiAgICAgIHNoaWZ0IDEKICAgICAgOzsKICAgIC1i
KQogICAgICBCTEFDS0xJU1Q9JDIKICAgICAgc2hpZnQgMQogICAgICA7OwogICAgLXcpCiAg
ICAgIFdISVRFTElTVD0kMgogICAgICBzaGlmdCAxCiAgICAgIDs7CiAgICAqKQogICAgICB1
c2FnZQogICAgICA7OwogIGVzYWMKICBzaGlmdCAxCmRvbmUKCiMgU2hvdyBjb25maWd1cmF0
aW9ucwplY2hvICJLcHJvYmUgc3RyZXNzIHRlc3Qgc3RhcnRpbmcuIgpbIC1mICIkQkxBQ0tM
SVNUIiBdICYmIGVjaG8gIkJsYWNrbGlzdDogJEJMQUNLTElTVCIgfHwgQkxBQ0tMSVNUPSIi
ClsgLWYgIiRXSElURUxJU1QiIF0gJiYgZWNobyAiV2hpdGVsaXN0OiAkV0hJVEVMSVNUIiB8
fCBXSElURUxJU1Q9IiIKWyAtZiAiJFNZTUxJU1QiIF0gJiYgZWNobyAiU3ltbGlzdDogJFNZ
TUxJU1QiIHx8IFNZTUxJU1Q9IiIKCmZ1bmN0aW9uIG1ha2VfZmlsdGVyICgpIHsKICBsb2Nh
bCBFWFA9IiIKICBpZiBbIC16ICIkV0hJVEVMSVNUIiAtYSAteiAiJEJMQUNLTElTVCIgXTsg
dGhlbgogICAgZWNobyAicy9eJC8vZyIKICBlbHNlCiAgICBmb3IgaSBpbiBgY2F0ICRXSElU
RUxJU1QgJEJMQUNLTElTVGAgO2RvCiAgICAgIFsgLXogIiRFWFAiIF0gJiYgRVhQPSJeJGlc
JCIgfHwgRVhQPSIkRVhQXFx8XiRpXCQiCiAgICBkb25lIDsgRVhQPSJzLyRFWFAvL2ciCiAg
ICBlY2hvICRFWFAKICBmaQp9CgpmdW5jdGlvbiBsaXN0X2FsbHN5bXMgKCkgewogIGxvY2Fs
IHN5bQogIGxvY2FsIG91dD0xCiAgZm9yIHN5bSBpbiBgc29ydCAvcHJvYy9rYWxsc3ltcyB8
IGVncmVwICdbMC05YS1mXSsgW1R0XSBbXltdKiQnIHwgY3V0IC1kXCAgLWYgM2A7ZG8KICAg
IFsgJHN5bSAgPSAiX19rcHJvYmVzX3RleHRfc3RhcnQiIF0gJiYgb3V0PTAgJiYgY29udGlu
dWUKICAgIFsgJHN5bSAgPSAiX19rcHJvYmVzX3RleHRfZW5kIiBdICYmIG91dD0xICYmIGNv
bnRpbnVlCiAgICBbICRzeW0gID0gIl9ldGV4dCIgXSAmJiBicmVhawogICAgWyAkb3V0IC1l
cSAxIF0gJiYgZWNobyAkc3ltCiAgZG9uZQp9CgpmdW5jdGlvbiBwcmVwX3Rlc3RpbmcgKCkg
ewogIGxvY2FsIGk9MAogIGxvY2FsIG49MAogIGxvY2FsIE5SPSQxCiAgbG9jYWwgZm5hbWU9
CgogIGVjaG8gIkdyb3VwaW5nIHN5bWJvbHM6ICROUiIKCiAgZm5hbWU9YHByaW50ZiAibGlz
dC0lMDNkLiVkIiAkaSAkTlJgCiAgY2F0ICRTWU1GSUxFIHwgd2hpbGUgcmVhZCBsbjsgZG8K
ICAgIFsgLXogIiRsbiIgXSAmJiBjb250aW51ZQogICAgZWNobyAiJGxuIiA+PiB0ZXN0aW5n
LyRmbmFtZQogICAgbj0kKChuKzEpKQogICAgaWYgWyAkbiAtZXEgJE5SIF07IHRoZW4KICAg
ICAgbj0wCiAgICAgIGk9JCgoaSsxKSkKICAgICAgZm5hbWU9YHByaW50ZiAibGlzdC0lMDNk
LiVkIiAkaSAkTlJgCiAgICBmaQogIGRvbmUKICBzeW5jCn0KCmZ1bmN0aW9uIGluaXRfZmly
c3QgKCkgewogIGxvY2FsIEVYUAogIEVYUD1gbWFrZV9maWx0ZXJgCiAgaWYgWyAtZiAiJFNZ
TUxJU1QiIF07IHRoZW4KICAgIGNhdCAkU1lNTElTVCB8IHNlZCAkRVhQID4gJFNZTUZJTEUK
ICBlbHNlCiAgICBlY2hvIC1uICJHZW5lcmF0aW5nIHN5bWJvbCBsaXN0IGZyb20gL3Byb2Mv
a2FsbHN5bXMuLi4iCiAgICBsaXN0X2FsbHN5bXMgfCBzZWQgJEVYUCA+ICRTWU1GSUxFCiAg
ICBlY2hvICJkb25lLiAiIGB3YyAtbCAkU1lNRklMRSB8IGN1dCAtZjEgLWRcICBgICJzeW1i
b2xzIGxpc3RlZC4iCiAgZmkKICBta2RpciAtcCB0ZXN0aW5nIGZhaWxlZCB1bnNldCBwYXNz
ZWQgcGFzc2VkL3Byb2ZpbGVzCiAgcHJlcF90ZXN0aW5nICRJTklUTlIKfQoKZnVuY3Rpb24g
Z2V0X21heF9uciAoKSB7CiAgd2MgLWwgZmFpbGVkL2xpc3QtKiB1bnNldC9saXN0LSogMj4v
ZGV2L251bGwgfFwKICBhd2sgJy9eICpbMC05XSsgLipsaXN0LiokL3sgaWYgKG5yIDwgJDEp
IG5yPSQxIH0gQkVHSU4geyBucj0wIH0gRU5EIHsgcHJpbnQgbnJ9Jwp9CgpmdW5jdGlvbiBp
bml0X25leHQgKCkgewogIGxvY2FsIE5SCiAgTlI9YGdldF9tYXhfbnJgCiAgWyAkTlIgLWVx
IDAgXSAmJiByZXR1cm4gMQogIFsgJE5SIC1lcSAxIF0gJiYgcmV0dXJuIDIKICBbICROUiAt
bGUgJERJViBdICYmIE5SPTEgfHwgTlI9YGV4cHIgJE5SIC8gJERJVmAKCiAgY2F0IGZhaWxl
ZC8qIHVuc2V0LyogPiAkU1lNRklMRQogIHJtIGZhaWxlZC8qIHVuc2V0LyoKCiAgcHJlcF90
ZXN0aW5nICROUgogIHJldHVybiAwCn0KCgojIEluaXRpYWxpemUgc3ltYm9scwppZiBbICEg
LWQgdGVzdGluZyBdOyB0aGVuCiAgaW5pdF9maXJzdAplbGlmIFsgLXogImBscyB0ZXN0aW5n
L2AiIF07IHRoZW4KICBpbml0X25leHQKZmkKCmZ1bmN0aW9uIHNldF9wcm9iZXMgKCkgewog
IGxvY2FsIHMKICBmb3IgcyBpbiBgY2F0ICQxYDsgZG8KICAgIGVjaG8gInA6JHMiICRzID4+
ICRERUJVR0ZTL3RyYWNpbmcva3Byb2JlX2V2ZW50cwogICAgWyAkPyAtbmUgMCBdICYmIHJl
dHVybiAtMQogIGRvbmUKICByZXR1cm4gMAp9CgpmdW5jdGlvbiBjbGVhcl9wcm9iZXMgKCkg
ewogIGVjaG8gPiAkREVCVUdGUy90cmFjaW5nL2twcm9iZV9ldmVudHMKfQoKZnVuY3Rpb24g
c2F2ZV9wcm9maWxlICgpIHsKICBjYXQgJERFQlVHRlMvdHJhY2luZy9rcHJvYmVfcHJvZmls
ZSA+IHBhc3NlZC9wcm9maWxlcy8kMS5wcm9mCn0KCmNsZWFyX3Byb2JlcwoKZWNobyAiU3Rh
cnRpbmcgdGVzdHMuLiIKClJFVD0wCgojIE1haW4gbG9vcAp3aGlsZSBbICRSRVQgLWVxIDAg
XTsgZG8KCiAgZm9yIGxpc3QgaW4gYGNkIHRlc3RpbmcvOyBsc2A7IGRvCiAgICBlY2hvIC1u
ICRsaXN0CiAgICAjIFRlbXBvcmFyeSBtb3ZpbmcgbGlzdCBpbnRvIGZhaWxlZC4KICAgIG12
IHRlc3RpbmcvJGxpc3QgZmFpbGVkLwogICAgc3luYztzeW5jCiAgICBlY2hvIC1uICJzeW5j
Li4iCiAgICBzZXRfcHJvYmVzIGZhaWxlZC8kbGlzdAogICAgaWYgWyAkPyAtbmUgMCBdOyB0
aGVuCiAgICAgIGNsZWFyX3Byb2JlcwogICAgICBzeW5jO3N5bmMKICAgICAgZWNobyAiY2Fu
IG5vdCBzZXQiCiAgICAgIG12IGZhaWxlZC8kbGlzdCB1bnNldC8KICAgICAgc3luYztzeW5j
CiAgICBlbHNlCiAgICAgIGRvX3Rlc3QKICAgICAgc2F2ZV9wcm9maWxlICRsaXN0CiAgICAg
IGNsZWFyX3Byb2JlcwogICAgICBzeW5jO3N5bmMKICAgICAgZWNobyAiZG9uZSIKICAgICAg
bXYgZmFpbGVkLyRsaXN0IHBhc3NlZC8KICAgICAgc3luYztzeW5jCiAgICBmaQogIGRvbmUK
CiAgaW5pdF9uZXh0CiAgUkVUPSQ/CmRvbmUKCmlmIFsgJFJFVCAtZXEgMSBdO3RoZW4KICAj
IE5vIGZhaWxlZCBzeW1ib2xzCiAgZWNobyAibm8gZmFpbGVkIHN5bWJvbHMgZm91bmQuIgpl
bHNlCiAgZWNobyAiZm91bmQgZmFpbGVkIHN5bWJvbHM6IgogIGNhdCBmYWlsZWQvKiB8IHRl
ZSAkRkFJTEZJTEUKICBybSBmYWlsZWQvKgpmaQoKZnVuY3Rpb24gcHJvZmlsZV9zeW1ib2xz
ICgpIHsKICBsb2NhbCBzIGggbQogIHJtIC1mIHRlc3RlZC5saXN0IG1pc3NlZC5saXN0IHVu
dGVzdGVkLmxpc3QKICBjYXQgcGFzc2VkL3Byb2ZpbGVzLyoucHJvZiB8IHdoaWxlIHJlYWQg
cyBoIG0gO2RvCiAgICBpZiBbICRoIC1uZSAwIF07IHRoZW4gCiAgICAgIGVjaG8gJHMgPj4g
dGVzdGVkLmxpc3QKICAgIGVsaWYgWyAkbSAtbmUgMCBdOyB0aGVuCiAgICAgIGVjaG8gJHMg
Pj4gbWlzc2VkLmxpc3QKICAgIGVsc2UKICAgICAgZWNobyAkcyA+PiB1bnRlc3RlZC5saXN0
CiAgICBmaQogIGRvbmUKfQoKZWNobyAtbiAiUHJvZmlsaW5nIHN5bWJvbHMuLi4iCnByb2Zp
bGVfc3ltYm9scwplY2hvIGRvbmUKZWNobyB0ZXN0ZWQ6IGB3YyAtbCB0ZXN0ZWQubGlzdCB8
IGN1dCAtZFwgIC1mMWAgc3ltYm9scwplY2hvIG1pc3NlZDogYHdjIC1sIG1pc3NlZC5saXN0
IHwgY3V0IC1kXCAgLWYxYCBzeW1ib2xzCmVjaG8gdW50ZXN0ZWQ6IGB3YyAtbCB1bnRlc3Rl
ZC5saXN0IHwgY3V0IC1kXCAgLWYxYCBzeW1ib2xzCg==
--------------000702000009000002030102--
