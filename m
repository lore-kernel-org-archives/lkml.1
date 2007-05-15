Return-Path: <linux-kernel-owner+w=401wt.eu-S934536AbXEOMGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536AbXEOMGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758357AbXEOMGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:06:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:34360 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbXEOMGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eOJnDlh0+NRbdySygbSIrNd867ydeSy3LPDdr7s0/L9sYTFJKMIyxN2jB4DEqVi1rlGW8fgDKrFu+xlFCxTf5bi3xpncaNXb/H/JEI8m14AneYhd7Zq33SlbFqMM6ot4XB9MwIp22Kaa4Og6QUzZDb1RJlbc60Q0plD9sEoFqbU=
Message-ID: <a4e6962a0705150506j291e17b8g3fc8db1ed83f43c1@mail.gmail.com>
Date: Tue, 15 May 2007 07:06:30 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 2/14] Add a new mount flag (MNT_UNION) for union mount
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <20070515081652.GD3465@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514093902.GD4139@in.ibm.com>
	 <Pine.LNX.4.61.0705142237270.9570@yvahk01.tjqt.qr>
	 <20070515081652.GD3465@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
>
> So there can be two cases in union mounts:
> 1. A file exists in topmost layer and also in one or more lower layers. Deleting
> the file would result in the top layer file being deleted and a whiteout being
> created in the top layer.
>
> 2. A file exists in one or more of lower layers, but not in the topmost layer.
> Deleting this file would result in just a whiteout being created in the
> topmost layer.
>

I'd imagine there is a third potential option, which I'll admit strays
a bit from the conventional UNIX semantic.  If only one layer is
marked as writable, then any changes (including delete) only effect
that layer.  I could imagine this would be useful in situations like
overlaying a sandbox on an otherwise read-only source code tree (you
might want to just get rid of a modification by removing your file and
have it replaced by the original underlying source).

I suppose a further extension would be to have multiple layers marked
as mutable and functions such as delete would effect all mutable
layers, but functions like create would only affect the top mutable
layer.

As an aside, perhaps it would be useful to mark the mutable layer at
mount time (instead of having it always be the top layer).  Again this
could lead to some optional non-conventional file system semantics,
but its proven useful in Plan 9 union mount semantics and it seems a
fairly trivial extension to what you currently have.

                     -eric
