Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753155AbYLQTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYLQTjt (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYLQTjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:39:25 -0500
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4269 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbYLQTjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:39:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Subject: Re: [BUG] cdev_put() race condition
Date: Wed, 17 Dec 2008 20:39:03 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <200812082156.26522.hverkuil@xs4all.nl> <20081217181645.GA26161@kroah.com> <200812172030.32535.hverkuil@xs4all.nl>
In-Reply-To: <200812172030.32535.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172039.03436.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008 20:30:32 Hans Verkuil wrote:
>
> This solves this particular problem. But this will certainly break v4l as
> it is right now, since the spin_lock means that the kref's release cannot
> do any sleeps, which is possible in v4l. If we want to allow that in
> cdev, then the spinlock has to be replaced by a mutex. But I have the
> strong feeling that that's not going to happen :-)

Note that if we ever allow drivers to hook in their own release callback, 
then we certainly should switch to a mutex in the cdev struct, rather than 
a global mutex. It obviously makes life more complicated for cdev, but much 
easier for drivers.

Regards,

 	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
