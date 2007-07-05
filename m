Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbXGERTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbXGERTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXGERTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:19:13 -0400
Received: from 70-91-206-189-BusName-SFBA.hfc.comcastbusiness.net ([70.91.206.189]:38390
	"EHLO nondot.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbXGERTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:19:12 -0400
X-Greylist: delayed 1289 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 13:19:12 EDT
Date: Thu, 5 Jul 2007 10:02:00 -0700 (PDT)
From: Chris Lattner <sabre@nondot.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
In-Reply-To: <20070705165347.GN21478@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.62.0707051000580.17173@nondot.org>
References: <20070705093528.GK21478@ftp.linux.org.uk>
 <alpine.LFD.0.98.0707050930330.9434@woody.linux-foundation.org>
 <20070705165347.GN21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Al Viro wrote:
> On Thu, Jul 05, 2007 at 09:41:55AM -0700, Linus Torvalds wrote:
>>> Note that gcc rules for __attribute__() (and that's the only source
>>> of rules we _have_ for the damn thing) clearly say that
>>> 	int __user *p;
>>> is the same thing as
>>> 	int *__user p;
>>
>> Quick question: is there some reason why we have to honor the crazy gcc
>> rules, and cannot try to convince gcc people that they are insane?
>
> AFAICS, they started with storage-class-like attributes.  Consider e.g.
> always_inline or section; these are not qualifiers at all and you want
> to have
> static __attribute__((always_inline)) int foo(int *p);
> interpreted with attribute applied to foo, not to its return type.

This is true, but I don't think this is related.  attributes in GCC can 
apply either to types or two decls.  In this case, the always_inline 
attribute is being applied to the decl, but other attributes could be 
applied to the return type.

-Chris

-- 
http://nondot.org/sabre/
http://llvm.org/
