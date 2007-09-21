Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbXIUOyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbXIUOyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbXIUOvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:51:33 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:15316 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761106AbXIUOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:51:30 -0400
X-Greylist: delayed 626 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2007 10:51:30 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=vQxDd7BjYBGwlb8EVkfk3hiBFtri/MYJzqEE+A1hkzna1tIkmoD4kOE5YwDddQHAZxq5u6LW5aLHkH1jnDxrG69xHqb9b8EiZeNCJHGsVp1fRbaqBvX++7IEnOyCqg6y;
X-IronPort-AV: E=Sophos;i="4.20,284,1186376400"; 
   d="scan'208";a="352263723"
Date: Fri, 21 Sep 2007 09:40:53 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Frank Cusack <fcusack@fcusack.com>, linux-ppp@vger.kernel.org
Subject: Re: [PATCH] ppp_mppe: Don't put InterimKey on the stack
Message-ID: <20070921144053.GA28101@auslistsprd01.us.dell.com>
References: <46F3D049.4080006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F3D049.4080006@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 04:08:09PM +0200, Michal Schmidt wrote:
> Hello,
> 
> The interrupt stack can be in the __START_KERNEL_map region in which
> virt_to_page will not work. This caused ppp_mppe to crash on CentOS 5 on x86_64
> (http://bugs.centos.org/view.php?id=2076).
> 
> The fix is to avoid copying the interim key. We can simply use it in its
> original place, which is kmalloc'd.

Needs a Signed-off-by: line, but otherwise, looks good, and even saves
some stack space.  Thanks for tracking this down.

-Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
