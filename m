Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYB0R0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYB0R0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 12:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYB0RZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 12:25:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:51201 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbYB0RZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=se2N2unNH1mFPGdwTyilxST9DmqF4jbhC38MjdLuktes31QQdoX8qxrKPSokAiE4H9Wx8GbWOAxf8GvLq+T4+0O2OT4hKLMbwBydv1bSrbMNi1PYgqufCK+ekoy4KQH9XDXiVj5g9+XYctSn/KpEtLj+F6A+lA+s+Gq/Ui67wUk=
Message-ID: <86802c440802270925y2ed9b208j32f4d61d460c0c7@mail.gmail.com>
Date: Wed, 27 Feb 2008 09:25:35 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing boot failure
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "Christoph Lameter" <clameter@sgi.com>,
       "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <47C575BE.3090603@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080203171634.58ab668b.akpm@linux-foundation.org>
	 <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie>
	 <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie>
	 <47B77E90.5050809@sgi.com> <47BAFFD3.1070606@sgi.com>
	 <20080219192319.GE12386@csn.ul.ie>
	 <86802c440802262229t37c61c98y45607ba34d7c6417@mail.gmail.com>
	 <47C575BE.3090603@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 6:37 AM, Mike Travis <travis@sgi.com> wrote:
>
> Yinghai Lu wrote:
>  > On Tue, Feb 19, 2008 at 11:23 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>  >> On (19/02/08 08:12), Mike Travis didst pronounce:
>  >>
>  >>> Mike Travis wrote:
>  >>  > > Mel Gorman wrote:
>  >>  > >
>  >>  > >> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
>  >>  > >> on the machine in question. Reverting didn't work out very well as there are
>  >>  > >> too many collisions with patches that were applied later. I eventually got
>  >>  > >> the machine booting but it only succeeds because it only brings up one core
>  >>  > >> on each processor.  The patch, which is pretty brain damaged is below in case
>  >>  > >> it helps you guess what the real problem is. dmesg logs are attached of the
>  >>  > >> vanilla failure with acpi=debug and the log with the patch applied showing
>  >>  > >> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
>  >>  > >> each machine).
>  >>  > >>
>  >>  > >
>  >>  > > This should completely undo the change to 16 bit apic ids until we can figure
>  >>  > > out the problem with the memory-less nodes.  I checked it on both the numa
>  >>  > > and non-numa x86_64 box.
>  >>  > >
>  >>  > > Thanks,
>  >>  > > Mike
>  >>  > >
>  >>  >
>  >>  > Hi Mel,
>  >>  >
>  >>  > Did you get a chance to try out this patch to see if it cleared up the problem
>  >>  > booting on your x86_64 numa box?
>  >
>  > did it fail with x86.git#testing?
>  >
>  > YH
>
>  Hi,
>
>  My problem is that I haven't been able to set up a NUMA box where some of the nodes
>  have no memory.  The one box we have, the serial port doesn't work and it's in a lab
>  far, far away.  Everything else, it works fine.

x86.git#testing should be solid with numa and nodes without memory.

YH
