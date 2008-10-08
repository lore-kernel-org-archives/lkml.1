Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYJHEpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYJHEpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 00:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYJHEpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 00:45:45 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:43450 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750867AbYJHEpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 00:45:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vi6PvtGEXVIdvhbuxFr1Um0QGNnEuwMJk82d3cyehbzhBeZ+uw2uy0gfAw8fU6Ov7eWlLbcCG2sa4yRR0sDqonRt1rIo9acO9dKAD5lbnrrtAq86B+Gn3mzrC5U6itJz24hrvhthfHS6Lp2WjQ4QZe5Wsx0tQFVzDa/+/GLcNDg=  ;
X-YMail-OSG: GsTc9AAVM1nhsoINWoxQaIDLhN9vL2QFSQ3Z7d4NRAJ1bKwYxx5.mwLMTChQd4ToH3dA2i3lL7pSjCmQqfqPExeuVNqd6fpfkqmoa2L6vRllV6scYmK_rlJ2bjz8FSkkOkMbw8GnB13.ONS0NiOxrUDrQULQoZNbIxn0MRVyig--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Thiago Lacerda" <thiagotbl@gmail.com>
Subject: Re: Questions about mmap
Date: Wed, 8 Oct 2008 15:45:36 +1100
User-Agent: KMail/1.9.5
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com> <48EB8912.7070407@s5r6.in-berlin.de> <3fedcc3b0810071009v68e5811ev11e9d512c58d371f@mail.gmail.com>
In-Reply-To: <3fedcc3b0810071009v68e5811ev11e9d512c58d371f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810081545.36369.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 04:09, Thiago Lacerda wrote:
> Thank you people.
>
> When I try to dereference those pointers in user space I get a segfault :(

Dereference the pointer returned from mmap? Or dereference the pointers
referenced by that pointer?

The first should be possible, and will give you an array of kernel pointers.
If you try to dereference those kernel pointers, yes you should get a segfault
because kernel memory is always mapped in the page tables as privileged.

If you're on x86, you could try adding _PAGE_USER to __PAGE_KERNEL_EXEC. That
would be a fairly wild ride :)

Hmm, you might be able vmap the kernel memory with
__pgprot(__PAGE_KERNEL | _PAGE_USER), and use that mapping from both user and
kernel space. Not guaranteed to be portable or even correct.

Best would be to rethink what exactly you are trying to do, and achieve it
some other way.
