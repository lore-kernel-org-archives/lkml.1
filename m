Return-Path: <linux-kernel-owner+w=401wt.eu-S1758589AbXJDOO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589AbXJDOO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 10:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbXJDOOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 10:14:50 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34971 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbXJDOOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 10:14:49 -0400
Message-ID: <4704F553.5020300@ext.bull.net>
Date: Thu, 04 Oct 2007 16:14:43 +0200
From: Gilles Carry <Gilles.Carry@ext.bull.net>
User-Agent: Mozilla Thunderbird 1.0 (X11/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Is it possible to have a robust futex outside of a mutex?
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 04/10/2007 16:21:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 04/10/2007 16:21:01,
	Serialize complete at 04/10/2007 16:21:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there is any way to use a robust futex without an associated mutex?
In the kernel, exit_robust_list only handles futexes associated with a mutex (through futex_offset).
Implementation of pthread_cond_xxx (broadcast, wait, ...) functions uses several futexes (lll_lock) in glibc which cannot be handled as robust.
However a thread locking one of these internal futexes can be killed while there are other waiters.
Am I right?

Thanks.
G+
