Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbXENTfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbXENTfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXENTfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:35:42 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34799 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbXENTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:35:41 -0400
Date: Mon, 14 May 2007 20:35:21 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Jan Blunck <jblunck@suse.de>
cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 14/14] tmpfs whiteout support
In-Reply-To: <4de7f8a60705141220j2764f326u69545490cdd23c08@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705142022090.21607@blonde.wat.veritas.com>
References: <20070514093722.GB4139@in.ibm.com>  <20070514094519.GP4139@in.ibm.com>
  <Pine.LNX.4.64.0705141710280.29949@blonde.wat.veritas.com>
 <4de7f8a60705141220j2764f326u69545490cdd23c08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 14 May 2007 19:35:41.0088 (UTC) FILETIME=[0E649200:01C7965F]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGpibHVuY2tAc3VzZS5kZQBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGxpbnV4LWZzZGV2ZWxAdmdlci5rZXJuZWwub3JnAGouYmx1bmNrQHR1LWhhcmJ1cmcuZGUAYmhhcmF0YUBsaW51eC52bmV0LmlibS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Jan Blunck wrote:
> On 5/14/07, Hugh Dickins <hugh@veritas.com> wrote:
> > >
> > > /* Pretend that each entry is of this size in directory's i_size */
> > > -#define BOGO_DIRENT_SIZE 20
> > > +#define BOGO_DIRENT_SIZE 1
> >
> > Why would that change be needed for whiteout support?
> 
> Good question. It seems that this a survivor of the changes necessary
> for union readdir.

(I'd be asking the same question in that case, but don't worry about it!)

> This isn't necessary for white-outs.

Phew, thanks, please drop that hunk.

> BTW: Why do we claim this to be 20??? Is there any meaning behind this?

No great meaning, hence "BOGO".  I put that in when hpa (IIRC) found
tmpfs directory size 0 didn't suit some apps.  I thought it would be
nice to have a size which indicates the current number of entries
(which your 1 would do), looks plausible (for short filenames),
and easy to make sense of in an "ls -l".  Bogus, yes; but I'd
resist changing it after all this time, without very good reason.

Hugh
