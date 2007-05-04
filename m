Return-Path: <linux-kernel-owner+w=401wt.eu-S1767568AbXEDLMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767568AbXEDLMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767898AbXEDLMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:12:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37047 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767568AbXEDLMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:12:43 -0400
Date: Fri, 4 May 2007 12:12:16 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Scott Murray <scottm@somanetworks.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpci_hotplug: Convert to use the kthread API
Message-ID: <20070504111215.GA3191@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Scott Murray <scottm@somanetworks.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
	Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769657702107-git-send-email-ebiederm@xmission.com> <20070422120534.GA20763@infradead.org> <Pine.LNX.4.64.0704271802390.3671@rancor.yyz.somanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704271802390.3671@rancor.yyz.somanetworks.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 06:07:49PM -0400, Scott Murray wrote:
> Sorry, it took me a few days to get to testing this out.  It looks good,    
> but I had to make a couple of tweaks to avoid a hang when rmmod'ing a
> board driver.  The board drivers do:
> 
> cpci_hp_stop()
> cpci_hp_unregister_controller(controller)
> 
> to shutdown, and the check in cpci_hp_unregister_controller if the thread
> is running wasn't working due to a bit too much code being excised.  The
> result was kthread_stop being called twice, which hangs.  I've indicated 
> my changes to avoid this inline below.

Can you forward the patches with your fix to Andrew to make sure he
picks it up?

