Return-Path: <linux-kernel-owner+w=401wt.eu-S939758AbXHNGv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939758AbXHNGv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbXHNGvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:51:17 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33246 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758074AbXHNGvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:51:16 -0400
Message-ID: <387074269.52680@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 14 Aug 2007 14:51:09 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       John Berthels <jjberthels@gmail.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] PSS(proportional set size) accounting in smaps
Message-ID: <20070814065108.GA5524@mail.ustc.edu.cn>
Mail-Followup-To: Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>,
	John Berthels <jjberthels@gmail.com>,
	Matt Mackall <mpm@selenic.com>
References: <46C13D43.8070502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C13D43.8070502@linux.vnet.ibm.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 10:57:31AM +0530, Balbir Singh wrote:
> I keep forgetting to check that you are on the cc. My email client
> loves dropping you from the to/cc list.

hehe, sorry for my crappy smtp server ;)

> Fengguang Wu wrote:
> > The "proportional set size" (PSS) of a process is the count of pages it has in
> > memory, where each page is divided by the number of processes sharing it. So if
> > a process has 1000 pages all to itself, and 1000 shared with one other process,
> > its PSS will be 1500.
> >                - lwn.net: "ELC: How much memory are applications really using?"
> > 
> > The PSS proposed by Matt Mackall is a very nice metic for measuring an process's
> > memory footprint. So collect and export it via /proc/<pid>/smaps.
> > 
> > Matt Mackall's pagemap/kpagemap and John Berthels's exmap can also do the job,
> > providing pretty much details.  But for PSS, let's do it in a simple way. 
> > 
> > Cc: Matt Mackall <mpm@selenic.com>
> > Cc: John Berthels <jjberthels@gmail.com>
> > Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> 
> I like the idea of moving towards PSS. I had sent some patches back in December
> last year
> 
> http://marc.info/?l=linux-mm&m=116738715329816&w=4

Thank you. That's a pretty comprehensive work.

> > -		if (page_mapcount(page) >= 2) {
> > +		mapcount = page_mapcount(page);
> > +		if (mapcount >= 2) {
> 
> This accounting is of-course racy. Mapcount can change any moment.

Sure it is: I never expect to provide accurate numbers.
The mapcount here is to prevent divide-by-zero errors.

> If we are reasonably sure that mapping will not change at the time
> of page_rmap_xxxxx() operations, we could handle shared accounting
> at those points and implement accurate shared accounting.

That would be desirable, if only we can keep the cost low ;)

