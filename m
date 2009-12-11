Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZLKSXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZLKSXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZLKSXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:23:47 -0500
Received: from vsmtp6.jaring.my ([192.228.250.86]:64937 "EHLO vsmtp6.jaring.my"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZLKSXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:23:46 -0500
Message-Id: <200912111823.nBBINTDe064090@vsmtp6.jaring.my>
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Sat, 12 Dec 2009 02:23:17 +0800
To: apparmor-dev@forge.novell.com, apparmor-dev@forge.novell.com,
       selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       fbac-lsm-general@lists.sourceforge.net
From: Lincoln Yeoh <lyeoh@pop.jaring.my>
Subject: Re: [Apparmor-dev] New security system FBAC-LSM announcement
  and call for collaborators
In-Reply-To: <4B22032F.906@ii.net>
References: <4B22032F.906@ii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 04:30 PM 12/11/2009, Cliffe wrote:

>I developed FBAC-LSM for my PhD research. FBAC-LSM restricts 
>programs based on the features each application provides. Reusable 
>policy abstractions, known as functionalities, can be used to grant 
>the authority to perform high level features (for example using the 
>Web_Browser functionality) or lower level features (such as using 
>the HTTP_Client functionality) or to grant privileges to access any 
>specified resources. Functionalities are parameterised, which allows 
>them to be adapted to the needs of specific applications. 
>Functionalities are also hierarchical; that is, functionalities can 
>contain other functionalities.

Looks good!

Been trying to get distros to implement something like this too, glad 
there's some progress :).

https://bugzilla.novell.com/show_bug.cgi?id=308760#c1

https://bugs.launchpad.net/ubuntu/+bug/156693

I think the slight difference is, with my proposal a program might 
actually request the "functionality" (I called it "sandbox template") 
it wants to be run with. This is not as crazy as it seems, since it 
means the program declares its limits upfront before the user or the 
OS says "that looks OK".

And these sandboxes (functionalities and custom functionalities) can 
be digitally signed (along with the programs).

Thus, a distro might sign sandboxes for certain apps - this way a 
desktop user will not need to be bothered or prompted for those apps.

A paranoid administrator can prevent the execution of programs that 
do not have acceptable sandboxes (only programs with very safe 
sandboxes and programs with "not so safe" sandboxes but are signed).

Also, a trusted 3rd party (security auditor etc) could audit a 
program and its sandbox, and if it looks ok, certify/sign it. Or 
maybe only certify it with a modified sandbox.

It should be easier to verify that a proposed sandbox is OK, than it 
is to verify that a program will be OK to run before running it 
(which is like solving a halting problem without the source code and 
full knowledge of the inputs ;) ).

The problem is we'd have to prevent the wrong programs from being run 
with the wrong custom sandboxes - the signature should take care of 
it - change the app and the signature + template + app should no 
longer be valid. However the problem is if the application is 
updated/patched, the signature won't be valid, but this might be a 
necessary tradeoff for custom sandboxes (or "full privilege" sandboxes).

Best regards,

Link.











