Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbZFPSNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbZFPSNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZFPSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:13:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZFPSN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:13:28 -0400
Date: Tue, 16 Jun 2009 20:13:26 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
Message-ID: <20090616181325.GC23969@random.random>
References: <4A37DEE7.1000208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37DEE7.1000208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 09:05:27PM +0300, Izik Eidus wrote:
> So the question is: is this thing is by desgin? (that kernel thread cant 
> call get_user_pages???), should i use something like switch_mm()??

I think switch_mm trick should be used for page faults, but gup
shouldn't require it because it gets the 'mm' as parameter and the
current->mm has to be irrelevant. current->mm is only relevant for
gup-fast (obviously :). So I think the only bit that needs fixing is
grab_swap_token to not run if current->mm is null.
