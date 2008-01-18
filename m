Return-Path: <linux-kernel-owner+w=401wt.eu-S1758998AbYARLrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998AbYARLrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbYARLrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:47:13 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:40223 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbYARLrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:47:12 -0500
Message-ID: <479091B5.4060700@cateee.net>
Date: Fri, 18 Jan 2008 12:47:01 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Jakob Oestergaard <jakob@unthought.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org> <20080118094826.GN25527@unthought.net>
In-Reply-To: <20080118094826.GN25527@unthought.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakob Oestergaard wrote:
> On Thu, Jan 17, 2008 at 01:25:39PM -0800, Linus Torvalds wrote:
> ...
>> Why do you make that mistake, when it is PROVABLY NOT TRUE!
>>
>> Try this trivial program:
>>
>> 	int main(int argc, char **argv)
>> 	{
>> 	        int i;
>> 	        const int *c;
>> 	
>> 	        i = 5;
>> 	        c = &i;
>> 	        i = 10;
>> 	        return *c;
>> 	}
>>
>> and realize that according to the C rules, if it returns anything but 10, 
>> the compiler is *buggy*.
> 
> That's not how this works (as we obviously agree).
> 
> Please consider a rewrite of your example, demonstrating the usefulness and
> proper application of const pointers:
> 
> extern foo(const int *);
> 
> int main(int argc, char **argv)
> {
>  int i;
> 
>  i = 5;
>  foo(&i);
>  return i;
> }
> 
> Now, if the program returns anything else than 5, it means someone cast away
> const, which is generally considered a bad idea in most other software
> projects, for this very reason.
> 
> *That* is the purpose of const pointers.

"restrict" exists for this reason. const is only about lvalue.

You should draw a line, not to make C more complex!

Changing the name of variables in your example:

extern print_int(const int *);

int main(int argc, char **argv)
{
   extern int errno;

   errno = 0;
   print_int(&i);
   return errno;
}

print_int() doesn't know that errno is also the argument.
and this compilation unit doesn't know that print_int() will
modify errno.

Ok, I changed int to extern int, but you see the point?
Do you want complex rules about const, depending on
context (extern, volatile,...) ?

ciao
	cate
