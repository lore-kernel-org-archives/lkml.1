Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZIKVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZIKVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZIKVZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:25:57 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:45226 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZIKVZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:25:56 -0400
Date: Fri, 11 Sep 2009 14:25:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: qla2xxx: Correct compilation issues when CONFIG_MOUDLES=n (was:
 Re: linux-next: Tree for September 7 (scsi/qla2x))
Message-Id: <20090911142548.b91cb917.randy.dunlap@oracle.com>
In-Reply-To: <20090911175341.GH710@plap4-2.local>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
	<20090907102747.ac6b98ff.randy.dunlap@oracle.com>
	<20090908182541.GB44157@plap4-2.local>
	<20090911175341.GH710@plap4-2.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AAAC05F.018C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 10:53:41 -0700 Andrew Vasquez wrote:

> Randy Dunlap noted:
> 
>   when CONFIG_MODULES=n:
> 
> 	drivers/scsi/qla2xxx/qla_os.c:2685: error: dereferencing pointer to incomplete type
> 
>   in
> 	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
> 		KOBJ_CHANGE, envp);
> 
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Ok, So any strong objections to just having the functionality present
> when module support is enabled?

Fine with me.  Thanks.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 29396c0..3887adb 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2671,6 +2671,7 @@ qla2x00_post_uevent_work(struct scsi_qla_host *vha, u32 code)
>  static void
>  qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
>  {
> +#ifdef CONFIG_MODULES
>  	char event_string[40];
>  	char *envp[] = { event_string, NULL };
>  
> @@ -2685,6 +2686,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
>  	}
>  	kobject_uevent_env(&(&vha->hw->pdev->driver->driver)->owner->mkobj.kobj,
>  	    KOBJ_CHANGE, envp);
> +#endif
>  }
>  
>  void
> 


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
