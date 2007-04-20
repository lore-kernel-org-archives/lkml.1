Return-Path: <linux-kernel-owner+w=401wt.eu-S1030757AbXDTSuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbXDTSuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030827AbXDTSuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:50:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030757AbXDTSuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:50:23 -0400
Date: Fri, 20 Apr 2007 14:49:56 -0400
From: Dave Jones <davej@redhat.com>
To: "Preston A. Elder" <prez@goth.net>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: AGPGart / AMD K7
Message-ID: <20070420184956.GD13939@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Preston A. Elder" <prez@goth.net>, linux-kernel@vger.kernel.org,
	greg@kroah.com
References: <46286775.5000507@goth.net> <20070420155537.GA20118@redhat.com> <4628F00B.3010304@goth.net> <20070420173337.GD20118@redhat.com> <462900BD.8020204@goth.net> <20070420182029.GF20118@redhat.com> <462906E5.8060609@goth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462906E5.8060609@goth.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 02:31:01PM -0400, Preston A. Elder wrote:

 > Here is the code for __pci_register_driver:
 > ...
 > 
 > So in the above case, we ARE saying if driver_register returns 0 then
 > pci_create_newid_file.
 > 
 > Is it different to the code you have?  As I said, this IS 2.6.19.

Yes, .20 changed this in this way..

@@ -445,9 +442,12 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner)
 
        /* register with core */
        error = driver_register(&drv->driver);
+       if (error)
+               return error;
 
-       if (!error)
-               error = pci_create_newid_file(drv);
+       error = pci_create_newid_file(drv);
+       if (error)
+               driver_unregister(&drv->driver);
 
        return error;
 }


Retry your tracing with .20 (or better yet, .21rc7/todays git)

	Dave

-- 
http://www.codemonkey.org.uk
