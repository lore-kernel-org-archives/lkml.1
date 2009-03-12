Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZCLJNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZCLJNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZCLJMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:12:50 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:48121 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751659AbZCLJMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:12:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ocnF1+8njtadaReQTYfmnEMI4M1WW9xm/j5d1THVKEhvhzkhWUIVHnILmn7UGqg6oX0liDxX04zaW6x7Q8hLFTLdaUuQ/BLTDfkRZoenOyz/mojpG5cBgO/rrB1gSshR1FdtGNFi2J10QS4vWYbdsfUUWHiNUVMZQZe6UfWKeV4=  ;
X-YMail-OSG: jcm57NQVM1nBr1P8ch8QdXLYAe6APRomnNR6vrAUUcYw7CG2DsONrUfLLMj9y1Ld.qN9w4zBB189YsTdf4t9G7HKXIsb1fdv0s3YCZ3LN2jg8Cmb5_.Jor6vrNZdjbVmLYrsmerzUWacVhwkvNsXt6ZXA4zoqi0EXvOM8aihArvFhdwGgNo04VKhl5iZszWOSvT0P2aPUOKoqjl_GfJOChBMeX0aCP55QYI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and fs
Date: Thu, 12 Mar 2009 20:12:45 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <m2hc2yulrw.fsf@gmail.com> <200903121922.53529.nickpiggin@yahoo.com.au> <38b2ab8a0903120200h2f586c41s58d6a1520cba5ea8@mail.gmail.com>
In-Reply-To: <38b2ab8a0903120200h2f586c41s58d6a1520cba5ea8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903122012.45607.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009 20:00:38 Francis Moreau wrote:
> On Thu, Mar 12, 2009 at 9:22 AM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > Ignore details like crashes, direct IO and coherency between data
> > mappings and buffercache where things get a bit hairy, and it's just a
> > writeback cache. The last thing you write to some location will be what
> > you get back if you read from that location -- regardless of whether it
> > is dirty or clean or not present when you ask for it (and has to be read
> > from disk).
>
> Well yes but I was wondering in the special where the kernel crash or
> the power supply is down how the kernel is minimizing the risk of file
> system inconsistency. Hence my questions about metadata handling.

Well, journalling filesystems, other filesystems can do synchronous
metadata updates (write through) which can help too. There is really
nothing that the generic pagecache/buffercache code does to try to
handle this because it is far to filesystem specific.

