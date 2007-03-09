Return-Path: <linux-kernel-owner+w=401wt.eu-S1767461AbXCIShE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767461AbXCIShE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767459AbXCIShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:37:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929AbXCIShB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:37:01 -0500
Date: Fri, 9 Mar 2007 10:36:56 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       zaitcev@redhat.com
Subject: Re: Fix locking in mousedev
Message-Id: <20070309103656.cd681677.zaitcev@redhat.com>
In-Reply-To: <d120d5000703090628p46556d52qb94b523fda4e947d@mail.gmail.com>
References: <20070228110631.86a150e4.zaitcev@redhat.com>
	<d120d5000703090628p46556d52qb94b523fda4e947d@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 09:28:49 -0500, "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
> On 2/28/07, Pete Zaitcev <zaitcev@redhat.com> wrote:

> > Dmitry, please consider getting rid of the list of handles entirely.
> > The other major user is drivers/char/keyboard.c.
> 
> I agree that handlers should not access h_list nad use their own
> private lists instead. However input core still needs that list to
> maintain its books.

Hmm. So it appears that my patch wastes 2 ulongs per input handle
then, in the name of preventing oopses. OK.

> I agree with the patch, unfortunately in lands squarely in the middle
> of me restructuring the code (swiitch to struct device, proper
> refcounting, etc) but I will try to adopt it.

Don't worry about this too much, I can always retest and resubmit,
as long as the main idea is agreeable to you. My users are on RHEL.
Therefore, my main concern is to get something into your tree in
order to avoid this regressing in the future. Meanwhile, users of
our 2.6.9 and 2.6.18 forks get a version of this patch.

-- Pete
