Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYJ3RvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYJ3RvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYJ3RvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:51:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:46050 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295AbYJ3RvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oik3/J5ainSCknVDjQoA7X2m/0l1Hk3Yu3+eOGMTiRYaKjo/jJ0m1XrJwSZBzlfNMp
         9QSu3mxAF4IMehKw4mBPaYHU9TzWYRHi/yuRmM65jQN+5M6XMamrnTjsWntDOmf8+pp1
         sbb0xTr2RL+k2qzPhQjxeYY14GejlbK1SB82c=
Message-ID: <524f69650810301051j7400a3f6m1840d06924ab8e89@mail.gmail.com>
Date: Thu, 30 Oct 2008 12:51:03 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [PATCH 0/4] cifs: fix oopses and mem corruption with concurrent mount/umount (try #4)
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081030134235.6d1276ae@barsoom.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
	 <524f69650810301025t3f3b7fb6t10d96b6567a67715@mail.gmail.com>
	 <20081030134235.6d1276ae@barsoom.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:42 PM, Jeff Layton <jlayton@redhat.com> wrote:
> I think we want to resist having locks that protect too many things.
> With that, we end up with the locks held over too much code. Not only is
> that generally worse for performance, but it can paper over race
> conditions.

I agree that it is trivially worse for performance to have a single
spinlock protecting the three interrelated structures (cifs tcp, smb
and tree connection structs), but since they point to one another and
frequently have operations that require us to use all three lists -
to do things like iterate through all tree connections within a
particular smb session, or iterate across all cifs smb sessions within
each cifs tcp session - it makes code more complicated to have to grab
and unlock multiple spinlocks in the correct order every time across
all exit paths etc.



-- 
Thanks,

Steve
