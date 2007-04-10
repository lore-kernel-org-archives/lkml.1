Return-Path: <linux-kernel-owner+w=401wt.eu-S1030921AbXDJQmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030921AbXDJQmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031098AbXDJQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:42:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:33790 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030921AbXDJQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Aq5qVxtFg29UEkhUHcb+yXDCNplmJksCbHV6QToxsZbBE/lkSLFtNURnuzwnWJbsTON0tN5qBBzuMS96RXCXZMe4V7gJW6h8zr586z8IEaKQLat/Ai51G2/vFzBKqkBBSeqC6tIoTrTP4Jb3i1kQjnD5uHfWF7V1XXwP9OMDkVs=
Message-ID: <a36005b50704100942t3602e92ar9a4362ad3d45434a@mail.gmail.com>
Date: Tue, 10 Apr 2007 09:42:07 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: If not readdir() then what?
Cc: "Theodore Tso" <tytso@mit.edu>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <461BB1C1.5050709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070407233037.GA16508@infradead.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org>
	 <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <20070410135641.GG13650@thunk.org>
	 <a36005b50704100710i28d5681fsdab6deb1d5161e28@mail.gmail.com>
	 <461BB1C1.5050709@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, H. Peter Anvin <hpa@zytor.com> wrote:
> It rather makes any user space accesses irrelevant.  The main question
> seems to be if we can realistically increase the cookie size even to 64
> bits.

On 32-bit platforms, *not* using _FILE_OFFSET_BITS=64 is already today
a stupid thing to do.  There are several places where things simply
break in today's world.

Once you do use 53-bit offsets (and we always do this for 64-bit
platforms) telldir returns a 64-bit cookie.  So, no problem.  The one
big issue is that there are no error values for telldir.  There was no
need so far.  But a) we can change this or b) we can really go
stronger in the direction to deprecate 32-bit ops and force people to
update their code.
