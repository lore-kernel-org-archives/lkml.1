Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZKMK6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZKMK6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbZKMK6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:58:50 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37144 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbZKMK6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AkhH7t0hJfPi2VE5tv8nToVMdDq0x/R6B3X5Jf5QD/0G8nIpD/bA5TbKDs9aCFYh1Z
         pa8mwW7DWZhc8MvlkqAfyEVzq2eN8bsVP0dXZu4259aMHjYMz51HA0Ef4QgIaiXaei9X
         Drcb/uT1XUPcmh/ctgyNqewYLrIzYFUGi42HE=
MIME-Version: 1.0
In-Reply-To: <1258068756-10766-15-git-send-email-vgoyal@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
	 <1258068756-10766-15-git-send-email-vgoyal@redhat.com>
Date: Fri, 13 Nov 2009 11:58:53 +0100
Message-ID: <4e5e476b0911130258v7b81902dlfcc298c72f2de63a@mail.gmail.com>
Subject: Re: [PATCH 14/16] blkio: Idle on a group for some time on rotational 
	media
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Fri, Nov 13, 2009 at 12:32 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> o If a group is not continuously backlogged, then it will be deleted from
>  service tree and loose it share. For example, if a single random seeky
>  reader or a single sequential reader is running in group.
>
Without groups, a single sequential reader would already have its 10ms
idle slice, and a single random reader on the noidle service tree
would have its 2ms idle, before switching to a new workload. Were
those removed in the previous patches (and this patches re-enable
them), or this introduces an additional idle between groups?

> o One solution is to let group loose it share if it is not backlogged and
>  other solution is to wait a bit for the slow group so that it can get its
>  time slice. This patch implements waiting for a group to wait a bit.
>
> o This waiting is disabled for NCQ SSDs.
>
> o This patch also intorduces the tunable "group_idle" which can enable/disable
>  group idling manually.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thanks,
Corrado
