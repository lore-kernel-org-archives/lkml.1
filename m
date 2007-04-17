Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbXDQOhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbXDQOhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXDQOhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:37:17 -0400
Received: from cs.columbia.edu ([128.59.16.20]:58907 "EHLO cs.columbia.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbXDQOhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:37:15 -0400
Message-ID: <4624DB46.6040400@cs.columbia.edu>
Date: Tue, 17 Apr 2007 10:35:50 -0400
From: Shaya Potter <spotter@cs.columbia.edu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: bharata@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  0/15] VFS based Union Mount
References: <20070417131459.GA4001@in.ibm.com>
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PerlMx-Spam: Gauge=IIIIIII, Probability=7%, X-Seen-By filter1.cs.columbia.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bharata B Rao wrote:
> Hi,
> 
> Here is an attempt towards vfs based union mount implementation.
> Union mount provides the filesytem namespace unification feature.
> Unlike the traditional mounts which hide the contents of the mount point,
> the union mount presents the merged view of the mount point and the
> mounted filesytem.

does this approach allow one to add directories to the union and have it 
behave normally.  namely when imagine one has the situation

dir-b
dir-a/ (contains file foo)


if one unions this and deletes foo, that will create a whiteout entry in 
dir-a

now, what happens if one does

dir-c
dir-b (now contains whiteout, from previous union).
dir-a (contains file foo)

will one see foo or not. i.e. are whiteouts only looked for in the 
topmost dir, or in every dir?
