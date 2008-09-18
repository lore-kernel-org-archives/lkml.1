Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYIRA5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYIRA5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 20:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYIRA5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 20:57:21 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57497 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYIRA5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 20:57:21 -0400
Message-ID: <28fa9c5e0809171757p59978419p810e7d0c571e33e6@mail.gmail.com>
Date: Thu, 18 Sep 2008 08:57:19 +0800
From: "Eugene Teo" <eugeneteo@kernel.sg>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext3: Avoid printk floods in the face of directory corruption
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Eric Sandeen" <sandeen@redhat.com>, linux-ext4@vger.kernel.org
In-Reply-To: <1221319971-29879-4-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221319971-29879-1-git-send-email-tytso@mit.edu>
	 <1221319971-29879-2-git-send-email-tytso@mit.edu>
	 <1221319971-29879-3-git-send-email-tytso@mit.edu>
	 <1221319971-29879-4-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 11:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Note: some people thinks this represents a security bug, since it
> might make the system go away while it is printing a large number of
> console messages, especially if a serial console is involved.  Hence,
> it has been assigned CVE-2008-3528, but it requires that the attacker
> either has physical access to your machine to insert a USB disk with a
> corrupted filesystem image (at which point why not just hit the power
> button), or is otherwise able to convince the system administrator to
> mount an arbitrary filesystem image (at which point why not just
> include a setuid shell or world-writable hard disk device file or some
> such).  Me, I think they're just being silly.

The description should explain what the problem is. And the last
sentence is a little ambiguous.

This is a user-triggerable DoS. The administrator who mounted the
filesystem image or partition might not know that the dir->i_size and
dir->i_blocks are corrupted. A remote user just need to perform either
a read or write operation to the mounted image or partition, and this
could trigger the problem, resulting in a denial of service.

Take note that another problem the test image shows is that, the
ext2/3 (and possibly ext4) filesystem does not honour the read-only
mode when the revision level is too high. That is, when
le32_to_cpu(es->s_rev_level) > EXT3_MAX_SUPP_REV. Eric replied me in a
private email that this is a different, and unrelated bug that will be
fixed.

Thanks, Eugene
