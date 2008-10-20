Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYJTQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYJTQwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYJTQwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:52:04 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35997 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYJTQwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:52:02 -0400
Subject: Re: [PATCH 02/10] Make checkpoint/restart functionality modular
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <1224285098-573-3-git-send-email-major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <1224285098-573-2-git-send-email-major@openvz.org>
	 <1224285098-573-3-git-send-email-major@openvz.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 09:51:59 -0700
Message-Id: <1224521519.1848.105.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 03:11 +0400, Andrey Mirkin wrote:
> +struct cpt_operations
> +{
> +       struct module * owner;
> +       int (*checkpoint)(pid_t pid, int fd, unsigned long flags);
> +       int (*restart)(int ctid, int fd, unsigned long flags);
> +};

I think this is pretty useless obfuscation.  We're not going to have
pluggable checkpoint/restart implementations, are we?  So, why bother
putting it in a module?

I can understand that it's easier to develop your code when it's in a
module and you don't have to reboot the machine to load a new kernel
each time.  But, that's an individual developer thing, and doesn't
belong in an upstream submission.

I know people have given you a hard time for this in the past.  Why is
it still here?

-- Dave

