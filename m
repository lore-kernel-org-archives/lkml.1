Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbZJNM1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbZJNM1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760026AbZJNM1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:27:18 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37206 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759634AbZJNM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=XQD/n9LyDpI9Dp4PUxpYxg/Guvu9rpEud1TlAoVbzMPWbEFmMJu1LjIL8g3ENlvevF
         F5GZls8joGPYguEuUyRx4uTiY0BdRQVj74ywtEcp/6qoSv/umactWG8TlOvjUVKsHHZC
         DjRxNGlbl7/Gv4CQ2/rs5hxbeBFKhIlXUQMlQ=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 14 Oct 2009 14:26:34 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com>
In-Reply-To: <20091013045556.GJ28435@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910141426.35338.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 October 2009, Sukadev Bhattiprolu wrote:
> +clone3(struct clone_struct * __user clone_args, pid_t * __user pids)
> +
> +       In addition to doing everything that clone() system call does,
> +       the clone3() system call:
> +
> +               - allows additional clone flags (all 32 bits in the flags
> +                 parameter to clone() are in use)
> +
> +               - allows user to specify a pid for the child process in its
> +                 active and ancestor pid name spaces.

Someone (sorry, can't find the old mail) pointed out last time that
the 'pid_t *__user tidptr' argument needs to be an independent pointer,
in order to allow the same use patterns with CLONE_CHILD_SETTID and
CLONE_CHILD_CLEARTID that you can do with the current clone
implementation.

Moving that argument from clone_struct into the argument list would
also make this a three-argument syscall, which solves the naming problem.

	Arnd <><
