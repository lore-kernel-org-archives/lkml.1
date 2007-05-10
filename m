Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXEJI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXEJI4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXEJI4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:56:10 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:26396 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbXEJI4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:56:09 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 1/6] IB/ehca: Serialize hypervisor calls in ehca_register_mr()
Date: Thu, 10 May 2007 10:55:46 +0200
User-Agent: KMail/1.8.2
Cc: LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
References: <200705091347.57470.fenkes@de.ibm.com>
In-Reply-To: <200705091347.57470.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705101055.46433.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2007 13:47, Joachim Fenkes wrote:

> --- a/drivers/infiniband/hw/ehca/hcp_if.c
> +++ b/drivers/infiniband/hw/ehca/hcp_if.c
> @@ -154,7 +154,9 @@ static long ehca_plpar_hcall9(unsigned l
>  			      unsigned long arg9)
>  {
>  	long ret;
> -	int i, sleep_msecs;
> +	int i, sleep_msecs, lock_is_set = 0;
> +	unsigned long flags;
> +
>  
>  	ehca_gen_dbg("opcode=%lx arg1=%lx arg2=%lx arg3=%lx arg4=%lx "
>  		     "arg5=%lx arg6=%lx arg7=%lx arg8=%lx arg9=%lx",
> @@ -162,10 +164,18 @@ static long ehca_plpar_hcall9(unsigned l

Whoops, that's one too many empty line...
Roland, when you apply this patch, could you apply the following patch on top:

--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -157,7 +157,6 @@ static long ehca_plpar_hcall9(unsigned l
        int i, sleep_msecs, lock_is_set = 0;
        unsigned long flags;

-
        ehca_gen_dbg("opcode=%lx arg1=%lx arg2=%lx arg3=%lx arg4=%lx "
                     "arg5=%lx arg6=%lx arg7=%lx arg8=%lx arg9=%lx",
                     opcode, arg1, arg2, arg3, arg4, arg5, arg6, arg7,


Thanks!
  Joachim

-- 
Joachim Fenkes  --  eHCA Linux Driver Developer and Hardware Tamer
IBM Deutschland Entwicklung GmbH  --  Dept. 3627 (I/O Firmware Dev. 2)
Schoenaicher Strasse 220  --  71032 Boeblingen  --  Germany
eMail: fenkes@de.ibm.com  --  Phone: +49 7031 16 1239


