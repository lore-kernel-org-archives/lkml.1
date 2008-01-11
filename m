Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbYAKP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbYAKP6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbYAKP61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:58:27 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:40184 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbYAKP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:58:26 -0500
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080111104258.2d1df3de@bree.surriel.com>
References: <20080108205939.323955454@redhat.com>
	 <20080108210002.638347207@redhat.com>
	 <20080111143627.FD64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080111104258.2d1df3de@bree.surriel.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 11 Jan 2008 10:59:18 -0500
Message-Id: <1200067158.5304.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 10:42 -0500, Rik van Riel wrote:
> On Fri, 11 Jan 2008 15:24:34 +0900
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > below patch is a bit cleanup proposal.
> > i think LRU_FILE is more clarify than "/2".
> > 
> > What do you think it?
> 
> Thank you for the cleanup, your version looks a lot nicer.  
> I have applied your patch to my series.
> 

Rik:  

I think we also want to do something like:

-	BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3);
+	BUILD_BUG_ON(LRU_INACTIVE_FILE != 2 || LRU_ACTIVE_FILE != 3 ||
+		NR_LRU_LISTS > 6);

Then we'll be warned if future change might break our implicit
assumption that any lru_list value with '0x2' set is a file lru.

Lee

