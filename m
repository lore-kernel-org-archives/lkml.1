Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYH0Jbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYH0Jbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYH0Jb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:31:26 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:50265 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753147AbYH0Jb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:31:26 -0400
To: linux-kernel@vger.kernel.org
Subject: Frustrated with capabilities..
From: Markku Savela <msa@moth.iki.fi>
Date: Wed, 27 Aug 2008 12:31:10 +0300
Message-ID: <87hc96by8x.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just want to run an exectable with limited capabilities and assumed
the following approach would work fine:

 1) fork process
 2) in child

    2.1 set current capabilities (eip) using cap_set_proc
    2.2 execve the executable.

But it frigging does not work! Just before the execve, the result of
cap_to_text is

    = cap_net_bind_service+eip

but, in the execve executable, the result is suddenly

    = cap_net_bind_service+i

Why does the execve clear the effective and permitted capabities,
against my clear instructions? (I also have the prctl KEEP_CAPS set,
though in this case it should be irrelevant).

- The kernel is from ubuntu distro, 2.6.24.

- the executable *does* *not* have any setuid/setgid bits

- the upcoming file capabities will not be any help, because I will
  need to start the same executable with different capabilities
  depending on context.

If this is not a bug in kernel, it is a misdesign, which makes the
obvious use of cap_set_proc rather useless...

-- 
Markku Savela
