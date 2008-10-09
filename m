Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbYJIPDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbYJIPDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYJIPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:03:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51227 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYJIPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:03:05 -0400
To: jens.axboe@oracle.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: splice vs O_APPEND
Message-Id: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Oct 2008 17:02:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the f_pos corruption thing, I found that splice() to
a regular file totally ignores O_APPEND.  Which allows users to bypass
the append-only restriction.  Bad...

The only question is how this should be solved?  Should splice()
respect O_APPEND and ignore the offset?  Or should it just return
-EINVAL?

Thanks,
Miklos
