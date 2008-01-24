Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYAXHtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYAXHtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYAXHtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:49:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbYAXHtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:49:06 -0500
Date: Wed, 23 Jan 2008 23:49:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhishek Rai <abhishekrai@google.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rohitseth@google.com
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
 patch]
Message-Id: <20080123234905.35664ed6.akpm@linux-foundation.org>
In-Reply-To: <200801230412.16992.abhishekrai@google.com>
References: <200801230412.16992.abhishekrai@google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Jan 2008 04:12:16 -0500 Abhishek Rai <abhishekrai@google.com> wrote:
> > I'm wondering about the interaction between this code and the
> > buffer_boundary() logic.  I guess we should disable the buffer_boundary()
> > handling when this code is in effect.  Have you reviewed and tested that
> > aspect?
> 
> Thanks for pointing this out, I had totally missed this issue in my change. I've now made the call to set_buffer_boundary() in ext3_get_blocks_handle() subject to metacluster option being set.
> 

Did it make any performance difference?  iirc the buffer_boundary stuff was
worth around 10% on a single linear read of a large, well-laid-out file.
