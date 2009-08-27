Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZH0OWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZH0OWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZH0OWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZH0OWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:22:44 -0400
Message-ID: <4A96969B.2090004@redhat.com>
Date: Thu, 27 Aug 2009 07:22:19 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Eric Blake <ebb9@byu.net>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net> <1251202593-3676-1-git-send-email-ebb9@byu.net> <alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com> <4A968FF8.8050109@byu.net>
In-Reply-To: <4A968FF8.8050109@byu.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 06:54 AM, Eric Blake wrote:
> I hope that my example shows why doing it in the kernel is desirable -
> there is no safe way to keep the pre-O_CLOEXEC efficiency using just the
> library, but there IS a way to do it with kernel support:

You're describing a very special case where the performance implications 
are really minimal and try to argue that is a good enough reason?  I 
don't think so.

If a program really has to do thousands of these safe open calls then it 
can invest time into opening /dev/null for any of the unallocated 
descriptors < 3.  You can even embed this logic in the safer_open function.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
