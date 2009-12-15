Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbZLOXg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbZLOXg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760701AbZLOXg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:36:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58300 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760098AbZLOXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:36:26 -0500
Date: Tue, 15 Dec 2009 23:37:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091215233738.26188500@lxorguk.ukuu.org.uk>
In-Reply-To: <20091215143446.8b6a7e57.akpm@linux-foundation.org>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
	<4AF8B4FF.9050405@zytor.com>
	<20091111153632.944a255c.akpm@linux-foundation.org>
	<20091215143446.8b6a7e57.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I merged this patch, but made a note-to-self that there are remaining
> > open issues..
> 
> And nothing else happened.  Can we revisit this please?

The last I saw was a request for an explanation of the users
configuration and how he was getting so many misc devices. Its a bug in
dlm if the dlm is doing that but I didn't see any follow up to the DLM
folks on the subject from the reporter, so it stays NACKed and conflicts
with the device registry.

We need to know from the DLM folks/Thaddeu what is actually going on with
that system, especially as it seems to be producing multiple
registrations of the same misc device name which is completely broken and
should probably be made to error anyway.

Whatever is going on this is the wrong "fix". If DLM should only register
it once (as seems the intent) then DLM needs fixing or the users config
or both. If it can register many then DLM needs fixing to not eat misc
devices.

<eviltwin>Possibly we need to make it BUG_ON() adding the same name twice, then
perhaps we'd get more feedback</eviltwin>

Alan
