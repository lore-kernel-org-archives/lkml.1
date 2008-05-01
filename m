Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYEAJrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYEAJrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbYEAJql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:46:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:17810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500AbYEAJqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CTD10FwFa/s6Jn4RHzjdz281e6o3nkyCpOHP+xPGBQZbMDFR39M15h7rX1zfq38tbXWINbmxcgx/HO9RVG0ZR4Bo1vlUPK4DKammEn6cD+pPyDdErlD8C3EcYNRybbClcJhCTR1RAYPGUTmkzsTWeePulJQMzkhTIdf70VXSD2g=
Message-ID: <48199175.7060906@gmail.com>
Date: Thu, 01 May 2008 15:46:29 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-1) Mnenhy/0.7.5.666
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Willy Tarreau <w@1wt.eu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <20080429111014.5a065b88@core> <20080429103335.GD1473@1wt.eu>
In-Reply-To: <20080429103335.GD1473@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> In my opinion, the problem is that when I press "é", the system sends
> two chars to the bash, which itself sends two chars to the terminal,
> which only displays one and moves the cursor one step ahead. Then,
> pressing backspace once sends one backspace all along, resulting in
> the terminal blanking one displayed char, but the shell not being
> aware that only half of it was removed. But if you look at how
> control chars are handled, if you display ^H then press backspace,
> you remove all of it. It's the terminal which adjusts the position
> depending on the character length.

export LANG=en_US.UTF-8 (i.e., inform the userspace that you are using UTF-8), 
unset LC_CTYPE and unset LC_ALL (so that they don't override $LANG), and problem 
solved.

-- 
Alexander E. Patrakov
