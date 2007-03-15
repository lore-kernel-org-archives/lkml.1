Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXCOU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXCOU7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbXCOU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:59:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:64385 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbXCOU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NReWJYoYfcgRubHOpp865pWBpBgFMpJSEtTNZihoNbOZI3QpDJj4fGo27vLT+4epsgRJ0G4K8jmKCWe0TEmfDJmqlt+3dUrcYyhGVMsYijD04Gnz71kGhS1ndwjWMk+EYPPcbBrAsHTrP59JEv5wJEzmzfn7QkkyxmZKP+3sjOc=
Message-ID: <a36005b50703151359r3aa951dbtfedda605c0966ff1@mail.gmail.com>
Date: Thu, 15 Mar 2007 12:59:09 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: thread stacks and strict vm overcommit accounting
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dan Aloni" <da-x@monatomic.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070313163320.GA28104@localdomain>
	 <20070315110621.9a9defaf.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/07, Hugh Dickins <hugh@veritas.com> wrote:
> I'm guessing that the pthread stacks are mmap'ed as greatest extents
> (probably because that's the easiest way to keep them apart), rather
> than as small MAP_GROWSDOWN areas to be expanded later on fault.

Please all, forget about MAP_GROWSDOWN.  It's useless.  If thread
stacks are not completely mapped (address space allocation, memory
allocation is not needed) it means subsequent unrelated mmaps can fall
into the address space which is meant to be used for the stack, hence
preventing the stack from growing.

libpthread uses an mmap for the complete stack size all the time and
this of course is accounted for in the kernel.
