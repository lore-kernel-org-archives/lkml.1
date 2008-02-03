Return-Path: <linux-kernel-owner+w=401wt.eu-S1765572AbYBCL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765572AbYBCL6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759382AbYBCL6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:58:06 -0500
Received: from ns1.suse.de ([195.135.220.2]:53571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbYBCL6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:58:05 -0500
Date: Sun, 3 Feb 2008 12:58:01 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@steeleye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080203115801.GA22650@wotan.suse.de>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de> <84144f020802030253y596ca557w3a44a8601a13596d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802030253y596ca557w3a44a8601a13596d@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 12:53:02PM +0200, Pekka Enberg wrote:
> Hi Nick,
> 
> On Feb 3, 2008 11:52 AM, Nick Piggin <npiggin@suse.de> wrote:
> > +asmlinkage void smp_call_function_fast_interrupt(void)
> > +{
> 
> [snip]
> 
> > +       while (!list_empty(&list)) {
> > +               struct call_single_data *data;
> > +
> > +               data = list_entry(list.next, struct call_single_data, list);
> > +               list_del(&data->list);
> > +
> > +               data->func(data->info);
> > +               if (data->wait) {
> > +                       smp_mb();
> > +                       data->wait = 0;
> 
> Why do we need smp_mb() here (maybe add a comment to keep
> Andrew/checkpatch happy)?

Yeah, definitely... it's just a really basic RFC, but I should get
into the habit of just doing it anyway.

Thanks,
Nick
