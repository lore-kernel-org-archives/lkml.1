Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZIVSHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZIVSHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZIVSHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:07:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44061 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZIVSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:07:12 -0400
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <20090922143223.GA31702@elte.hu>
References: <4AB3CDEC.5050902@zytor.com>
	 <1253342422-13811-1-git-send-email-avi@redhat.com>
	 <4AB8980D.5070803@redhat.com>  <20090922143223.GA31702@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 20:06:57 +0200
Message-Id: <1253642817.18939.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:32 +0200, Ingo Molnar wrote:

> Would be nice to convert some existing open-coded return-to-user-space 
> logic to this facility. One such candidate would be lockdep_sys_exit?

I don't really like lockdep_sys_exit() in such a call,
lockdep_sys_exit() is currently placed such that it will execute as the
last C code before returning to user-space.

Put it any earlier and you've got a window where people can leak a lock
to userspace undetected.

