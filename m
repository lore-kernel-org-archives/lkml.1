Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbZEEB72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbZEEB72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 21:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZEEB7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 21:59:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44934 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbZEEB7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 21:59:18 -0400
Date: Mon, 4 May 2009 18:59:36 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, xemul@parallels.com
Subject: Re: [PATCH 2/2] pidns 2/2: rewrite copy_pid_ns()
Message-ID: <20090505015936.GB6048@linux.vnet.ibm.com>
References: <20090503232721.GE16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503232721.GE16631@x200.localdomain>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan [adobriyan@gmail.com] wrote:
| copy_pid_ns() is a perfect example of a case where unwinding leads to more
| code and makes it less clear. Watch the diffstat.

Yes, its cleaner this way :-)

| 
| Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

| ---
|  kernel/pid_namespace.c |   18 +++---------------
|  1 files changed, 3 insertions(+), 15 deletions(-)
| 
| diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
| index 495d5de..821722a 100644
| --- a/kernel/pid_namespace.c
| +++ b/kernel/pid_namespace.c
| @@ -116,23 +116,11 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
| 
|  struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
|  {
| -	struct pid_namespace *new_ns;
| -
| -	BUG_ON(!old_ns);
| -	new_ns = get_pid_ns(old_ns);
|  	if (!(flags & CLONE_NEWPID))
| -		goto out;
| -
| -	new_ns = ERR_PTR(-EINVAL);
| +		return get_pid_ns(old_ns);
|  	if (flags & CLONE_THREAD)
| -		goto out_put;
| -
| -	new_ns = create_pid_namespace(old_ns);
| -
| -out_put:
| -	put_pid_ns(old_ns);
| -out:
| -	return new_ns;
| +		return ERR_PTR(-EINVAL);
| +	return create_pid_namespace(old_ns);
|  }
| 
|  void free_pid_ns(struct kref *kref)
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
