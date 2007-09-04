Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbXIDQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbXIDQjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbXIDQjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:39:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:28495 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbXIDQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XjOpGZ2Y1gILXUSVoR2zat87ZpxrIG0DjD5Vf2nUc+LByBuqX3MHSRr5ClWd3hmPuiHggeO1JLYSGMdyW3nMyv5JJPpgbQprRTR6GvxhtRh450jSyXyckBUNFPSdMD1heFbt35Dfd1O4DvMNJ+zape+bn7lZVrvPVimr07FwDwY=
Message-ID: <379fb4870709040939m2430be6ci57fd73f1f9abc6ef@mail.gmail.com>
Date: Tue, 4 Sep 2007 18:39:33 +0200
From: "anon... anon.al" <anon.asdf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Race condition: calling remove_proc_entry in cleanup_module (module_exit) while someone's using procfile
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

There is a race condition if an instance is executing "__exit
device_exit" and calls remove_proc_entry, while someone is still using
the procfile, right?.

static void __exit device_exit(void)
{
  // what if the procfile is still in use?
  remove_proc_entry(PROC_FILE_NAME, &proc_root);
}

To remove this race condition, the code in "__exit device_exit" must
a) be sure that no other instance is in procfile functions
b) call remove_proc_entry before any other instance accesses the procfile

*** Is this at all possible if a race-condition is to be avoided?
If yes: which mechanism can be used?

Thanks -Albert
