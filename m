Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbYAYBz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbYAYBz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYAYBzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:55:52 -0500
Received: from ag-out-0708.google.com ([72.14.246.243]:16843 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYAYBzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:55:51 -0500
Cc: Heikki Orsila <shdl@zakalwe.fi>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tigran@aivazian.fsnet.co.uk
Message-Id: <57F1F710-9135-413B-A811-88C1091389AC@moffetthome.net>
From: Kyle Moffett <kyle@moffetthome.net>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
In-Reply-To: <47991B7C.6000208@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header file
Date: Thu, 24 Jan 2008 20:55:47 -0500
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008, at 18:13, Dmitri Vorobiev wrote:
> Heikki Orsila пишет:
>> On Fri, Jan 25, 2008 at 01:32:04AM +0300, Dmitri Vorobiev wrote:
>>> +/* inode.c */
>>> +extern void dump_imap(const char *, struct super_block *);
>>> +
>>
>> Functions should not be externed, remove extern keyword.
>
> Care to explain why?
>
> Following is an explanation why the contrary is probably true:
>
> 1) We have lots of precedents in existing code:
>
> dmvo@cipher:~/Projects/misc/linux$ git-grep 'extern void' include |  
> wc -l
> 5523
> dmvo@cipher:~/Projects/misc/linux$


The "extern" keyword on functions is *completely* redundant.

For C variables:
   Declaration:  extern int foo;
   Definition:   int foo;
   File-scoped:  static int foo;

For C functions:
   Declaration:  void foo(int x);
   Definition:   void foo(int x) { /*...body...*/ }
   File-scoped:  static void foo(int x) { /*...body...*/ }

The compiler will *allow* you to use "extern" on the function  
prototype, but the presence or absence of a function body is  
sufficiently obvious for it to determine whether the prototype is a  
declaration or a definition that the "extern" keyword is not required  
and therefore redundant.

For maximum readability and cleanliness I recommend that you leave off  
the "extern" on the function declarations; it makes the lines much  
longer without obvious gain.

Cheers,
Kyle Moffett


