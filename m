Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0BVAXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 19:23:46 -0500
Received: from ozlabs.org ([203.10.76.45]:49886 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab0BVAXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 19:23:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: hang in call_usermodehelper_exec()
Date: Mon, 22 Feb 2010 10:53:32 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20100217202234.GD5256@x200>
In-Reply-To: <20100217202234.GD5256@x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002221053.32560.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 06:52:34 am Alexey Dobriyan wrote:
> I was stress-testing netns stuff in presence of removing modules.
> 
> Kernel is 2.6.33-rc8-next-20100217+:
> 
> At some point setkey(8) and modprobe hanged:
> 
> 3541 pts/1    D      0:00 /usr/sbin/setkey -f /root/ipcomp-tunnel.setkey
> 3737 pts/2    D      0:00 modprobe -r des_generic sha1_generic md5 hmac xfrm_user crypto_null af_packet xfrm4_mode_beet ipcomp xfrm_ipcomp  xfrm4_tunnel deflate zlib_deflate zlib_inflate esp4 xfrm4_mode_tran

Hmm, looks like sys_delete_module() is stuck trying to re-grab the
module_mutex.  But who's holding it?  We'd need a full task dump to see.

We do a stop_machine with the module mutex held, but not much else.  This
doesn't seem like that.  Do you have tracepoints, or dynamic debug enabled?

Puzzled,
Rusty.
-- 
Away travelling 25Feb-26Mar (6 .de + 1 .pl + 17 .lt + 2 .sg)
