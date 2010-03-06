Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0CFLEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:04:34 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60226 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0CFLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=jJuzo9uY7blj4mMsl4Ap4b15Vo7Qx86SzjymNirNym1sQlWburlPP/7j+BuM3YUp8e
         cyINk9KcLExiy1jFnV5o5LSE4a/8EcRYKR25KiGLbfHZl111qgDTjBt2HIckbZmY6jSw
         CDFK+Sm1ywwHY2NDbo0gMXzxfiXPUTJXlXVH0=
Date: Sat, 6 Mar 2010 14:04:14 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: vga_switcheroo: locking question in vga_switcheroo_debugfs_write()
Message-ID: <20100306110414.GB4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

drivers/gpu/vga/vga_switcheroo.c +362 vga_switcheroo_debugfs_write(101)
   277          mutex_lock(&vgasr_mutex);
   278
   279          if (!vgasr_priv.active)
   280                  return -EINVAL;

Is there a reason we return with the lock held here?  The other returns
from this function don't have the lock held.  I looked through the rest
of the file but didn't see any clues.

regards,
dan carpenter
