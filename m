Return-Path: <linux-kernel-owner+w=401wt.eu-S969850AbXILR6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969850AbXILR6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765995AbXILR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:57:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37352 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765600AbXILR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:57:53 -0400
Date: Wed, 12 Sep 2007 10:56:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Rogan Dawes <lists@dawes.za.net>, David Newall <david@davidnewall.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stripping down the kernel-parameters.txt file
Message-Id: <20070912105624.36b74f17.randy.dunlap@oracle.com>
In-Reply-To: <3E869809-EA55-4F90-B364-788081ACEC00@mac.com>
References: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
	<46E7DEF8.50201@davidnewall.com>
	<Pine.LNX.4.64.0709120904130.20693@localhost.localdomain>
	<46E7F816.9080806@dawes.za.net>
	<Pine.LNX.4.64.0709121034450.25084@localhost.localdomain>
	<3E869809-EA55-4F90-B364-788081ACEC00@mac.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__12_Sep_2007_10_56_24_-0700_JEFqUOcJCOgehd=p"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__12_Sep_2007_10_56_24_-0700_JEFqUOcJCOgehd=p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Sep 2007 13:47:38 -0400 Kyle Moffett wrote:

> On Sep 12, 2007, at 10:44:29, Robert P. J. Day wrote:
> > in the end, there should be a nice, *short* reference for what i  
> > like to call "basic" kernel parms (defined by __setup() or  
> > early_param()), while anyone who wants to learn about any module- 
> > specific parms should then have to go look up the info for that  
> > given module, that's all.
> >
> > as a trivial starting point, this would involve nothing more than  
> > shifting current content around in kernel-parameters.txt, putting  
> > the basic stuff at the top, and the module-specific stuff after  
> > that.  heck, that would even give module authors the chance to add  
> > a line or two of module description if they wanted.  how does life  
> > get any better than that?
> 
> Well, maybe if modules could be used similarly to: "modprobe  
> my_module --help" to give a description of the available module  
> parameters.  That information might be merged into modules from text  

modinfo prints out all MODULE_PARM_DESC() strings.

> file(s) or vice-versa, but I can see it being significantly more  
> useful.  Another mildly-useful feature would be to stick the basic  
> boot params and those for built-in modules into a little text file  
> which could optionally be embedded in the initramfs along with the  
> "less" binary, so that a "vmlinuz --help" could be made to work  
> usefully from your bootloader.

This has come up before.  I wrote the attached 'module-params'
script last October (2006).  It can search .c files or .ko files
for module parameters...

---
~Randy

--Multipart=_Wed__12_Sep_2007_10_56_24_-0700_JEFqUOcJCOgehd=p
Content-Type: application/octet-stream;
 name="module-params"
Content-Disposition: attachment;
 filename="module-params"
Content-Transfer-Encoding: base64

IyEgL2Jpbi9zaAojIENvcHlyaWdodCAoQykgMjAwNiBSYW5keSBEdW5sYXAKIyBHUEwgdmVyc2lv
biAyIGxpY2Vuc2UuCiMgcHJpbnRzICdtb2RpbmZvIC1wJyBmb3IgYWxsIGZvdW5kICoua28gZmls
ZXMKIyBwcmludHMgJ21vZGluZm8nIChhbGwpIGZvciBhbGwgZm91bmQgKi5rbyBmaWxlcyBpZiAt
YSBpcyBzcGVjaWZpZWQ7CiMgcHJpbnRzIGFsbCBNT0RVTEVfUEFSTV9ERVNDIGxpbmVzIGZvciBh
bGwgKi5jIGZpbGVzIGlmIC1zIGlzIHNwZWNpZmllZDsKCmFsbGluZm89IiIKc291cmNlcz0iIgoK
d2hpbGUgZ2V0b3B0cyAiYW9zaCIgT3B0aW9uIDsgZG8KCWNhc2UgJE9wdGlvbiBpbgoJYSkKCQlh
bGxpbmZvPSIxIgoJCTs7CglzKQoJCXNvdXJjZXM9IjEiCgkJOzsKCW8pCgkJc291cmNlcz0iIgoJ
CTs7CglofCopCgkJZWNobyAidXNhZ2U6IG1vZHVsZS1wYXJhbXMgWy1hXSBbLXNdIFstb10gWy1o
XSIKCQllY2hvICJsaXN0cyBtb2R1bGUgcGFyYW1ldGVyIGluZm8gZm9yIGFsbCBmb3VuZCBmaWxl
czoiCgkJZWNobyAiICAtcyBzZWFyY2hlcyBzb3VyY2UgKC5jKSBmaWxlcyIKCQllY2hvICIgIC1v
IHNlYXJjaGVzIGJpbmFyeSAoLmtvKSBmaWxlcyBbZGVmYXVsdF0iCgkJZWNobyAiICAtYSBsaXN0
cyBhbGwgbW9kaW5mbyBvdXRwdXQgZnJvbSAua28gZmlsZXMiCgkJZWNobyAiICAgICAoZWxzZSBq
dXN0IC1wOiBtb2R1bGUgcGFyYW1ldGVycyBvdXRwdXQpIgoJCWVjaG8gIiAgLWggcHJpbnRzIHRo
aXMgaGVscCB0ZXh0IgoJCWV4aXQKCQk7OwoJZXNhYwpkb25lCiMjZWNobyBzaGlmdGluZyBhcmdz
IGJ5OiAkKCgkT1BUSU5EIC0gMSkpCnNoaWZ0ICQoKCRPUFRJTkQgLSAxKSkKCmlmIFsgIiRhbGxp
bmZvIiA9PSAiMSIgXTsgdGhlbgoJbW9kaW5mb19wYXJhbT0iIgplbHNlCgltb2RpbmZvX3BhcmFt
PSItcCIJIyBtb2R1bGUgcGFyYW1ldGVycyBvbmx5CmZpCgppZiBbICIkc291cmNlcyIgPT0gIjEi
IF07IHRoZW4KCWZpbGVuYW1lcz0kKGZpbmQgLiAtbmFtZSBcKlwuYykKZWxzZQoJZmlsZW5hbWVz
PSQoZmluZCAuIC1uYW1lIFwqXC5rbykKZmkKCmZvciBmaWxlIGluICRmaWxlbmFtZXMgOyBkbwoK
CWlmIFsgIiRzb3VyY2VzIiA9PSAiMSIgXTsgdGhlbgoJCWdyZXAgLXNxIC13IE1PRFVMRV9QQVJN
X0RFU0MgJGZpbGUKCQlzdHM9JD8KCgkJaWYgWyAkc3RzIC1lcSAwIF07IHRoZW4KCQkJaWYgWyAk
e2ZpbGU6MDoyfSA9PSAiLi8iIF07IHRoZW4KCQkJCWZpbGU9JHtmaWxlOjJ9CgkJCWZpCgkJCWVj
aG8gIiRmaWxlOiIKCQkJZ3JlcCAtdyBNT0RVTEVfUEFSTV9ERVNDICRmaWxlIHwgXAoJCQkJc2Vk
IC1lIHMvTU9EVUxFX1BBUk1fREVTQ1tbOnNwYWNlOl1dKlwoLy8gfCBcCgkJCQlzZWQgLWUgcy8i
XCJbWzpzcGFjZTpdXSopW1s6c3BhY2U6XV0qO1tbOnNwYWNlOl1dKiQiLy8gfAoJCQkJc2VkIC1l
IHMvIiwiLyI6ICIvIHwKCQkJCXNlZCAtZSBzLyciJCcvJycvIHwKCQkJCXNlZCAtZSBzLydcXCQn
LycnLyB8CgkJCQlzZWQgLWUgcy8nXFxuJCcvJycvIHwKCQkJCXNlZCAtZSBzLydcXHQnLycgJy9n
IHwKCQkJCXNlZCAtZSBzLydcXG4nLyc6ICcvZyB8CgkJCQlzZWQgLWUgcy8nXFwnLycnL2cgfAoJ
CQkJc2VkIC1lIHMvJ19fTU9EVUxFX1NUUklORycvJycvZyB8CgkJCQlzZWQgLWUgcy8iOltbOnNw
YWNlOl1dKlwiIi8iOiAiLwoJCQllY2hvICItLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tIgoJCWZpCgoJZWxzZQkjIG9iamVjdCBtb2R1bGVzCgkJaW5mbz1g
bW9kaW5mbyAkbW9kaW5mb19wYXJhbSAkZmlsZWAKCQlpZiBbICIkaW5mbyIgIT0gIiIgXTsgdGhl
bgoJCQkjIGRvbid0IHJlcGVhdCBmaWxlbmFtZQoJCQlpZiBbICIkYWxsaW5mbyIgIT0gIjEiIF07
IHRoZW4KCQkJCWVjaG8gIiRmaWxlOiIKCQkJZmkKCQkJbW9kaW5mbyAkbW9kaW5mb19wYXJhbSAk
ZmlsZSB8IHNlZCAtZSBzLyI6Ii8iOiAiL2cKCQkJZWNobyAiLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSIKCQlmaQoKCWZpCgpkb25lCg==

--Multipart=_Wed__12_Sep_2007_10_56_24_-0700_JEFqUOcJCOgehd=p--
