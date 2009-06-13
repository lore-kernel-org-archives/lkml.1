Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbZFMLNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbZFMLNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 07:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZFMLMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 07:12:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZFMLMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 07:12:53 -0400
Date: Sat, 13 Jun 2009 13:12:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] perfcounters: Print the filename:line for
	annotated colored lines
Message-ID: <20090613111248.GA1355@elte.hu>
References: <1244844682-12928-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244844682-12928-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, -l doesnt work so well if a user-space binary (in this case the 
'git' binary of the Git project) is profiled:

aldebaran:~/git> perf record -f ./git gc
Counting objects: 1148, done.
Delta compression using up to 16 threads.
Compressing objects: 100% (450/450), done.
Writing objects: 100% (1148/1148), done.
Total 1148 (delta 690), reused 1148 (delta 690)
[ perf record: Captured and wrote 1.649 MB perf.data (~72032 samples) ]

aldebaran:~/git> perf annotate -l lookup_object

addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file
addr2line: 'vmlinux': No such file

------------------------------------------------
 Percent |      Source code & Disassembly of /home/mingo/git/git-update-server-info
------------------------------------------------
         :
         :      /home/mingo/git/git-update-server-info:     file format elf64-x86-64
         :
         :
         :      Disassembly of section .text:
         :
         :      00000000004160f0 <lookup_object>:
         :              memcpy(&i, sha1, sizeof(unsigned int));
         :              return (int)(i % obj_hash_size);
         :      }

	Ingo
