Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbXEJAtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbXEJAtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbXEJAtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:49:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58724 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696AbXEJAtf (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:49:35 -0400
Date: Thu, 10 May 2007 10:49:18 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an nlink problem?
Message-ID: <20070510004918.GS85884050@sgi.com>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46426194.3040403@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 05:04:36PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > Seems very unlikely. Have you unmounted and mounted the filesystem
> > (or rebooted or suspended) between the files being seen good and
> > the files being seen bad?
> >   
> 
> There was definitely a suspend-resume, and maybe a reboot.  I'll try
> again later on.

Suspend-resume, eh?

There's an immediate suspect. Can you test this specifically for us?
i.e. download a known good file set, do some stuff, suspend, resume,
then check the files? If it doesn't show up the first time, can
you do it a few times just to rule it out?

If suspend/resume does cause the problem, can you try again but this
time please run 'xfs_freeze -f <mtpt>' on the filesystem before
suspend, and then 'xfs_freeze -u <mtpt>' after the resume and see if
the problem still occurs?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
