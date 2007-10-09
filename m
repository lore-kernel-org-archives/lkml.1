Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbXJIO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbXJIO4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXJIO4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:56:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:46690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbXJIO4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:56:10 -0400
To: Michael Stiller <ms@2scale.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: howto boost write(2) performance?
References: <1191937817.3641.9.camel@blackberry>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Oct 2007 16:56:09 +0200
In-Reply-To: <1191937817.3641.9.camel@blackberry>
Message-ID: <p73odf849rq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stiller <ms@2scale.net> writes:
> 
> The write(2) performance is not good enough, the writer threads take to
> much time, and i ask you for ideas, howto to boost the write
> performance. 

You could use an O_DIRECT write if the data is suitably aligned
and your IO sizes are big enough (O_DIRECT is usually a loss
on small IOs). It will also be synchronous, but if you do it 
from a separate thread anyways that should be fine.

-Andi
