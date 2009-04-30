Return-Path: <linux-kernel-owner+w=401wt.eu-S1765417AbZD3S7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765417AbZD3S7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 14:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764502AbZD3S7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 14:59:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:45707 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764694AbZD3S67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 14:58:59 -0400
Date: Thu, 30 Apr 2009 20:58:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Marc Pignat <Marc.Pignat@hevs.ch>,
       Roger Quadros <ext-roger.quadros@nokia.com>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc4 hid bluetooth not working
In-Reply-To: <1241103783.3389.35.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.0904302056270.5012@wotan.suse.de>
References: <49F9C1AD020000BF00029086@mailgw2.hevs.ch>  <alpine.LRH.2.00.0904301556310.2050@twin.jikos.cz> <1241103783.3389.35.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Marcel Holtmann wrote:

> > > My bluetooth keyboard is not working any more in rc4, but was 
> > > working in rc3. Here is the dmesg output, triggered by the first key 
> > > press on the keyboard, fortunately, this is 100% reproductible (once 
> > > per boot).
> > Does reverting f3784d834c7 fix the problem?
> we have seen a similar report where reverting f3784d834c7 didn't fix it. 
> And I don't see anything wrong with that patch. Did something important 
> got changed in the work queue code that I am missing?

Calling flush() from work->func() is not safe. That's what the WARN_ON() 
in flush_cpu_workqueue() is there for, right?

-- 
Jiri Kosina
SUSE Labs
