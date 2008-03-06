Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbYCFLtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbYCFLtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYCFLtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:49:08 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:64073 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbYCFLtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:49:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FZcZKUUdL1RkLI3tzGwW7SfpQe/LUspZ1kBklpOdWl1wzXM/nCPPbZPX36+ofQUI3jVlqkgMOS7YE0idNfEkGU3iSZvKxUSnZq4y/zVvATfMUkscHQ+wdUTQX/SY1Tune2My6XU/F7bXY0TLrV1VX0+ndb/TA67Ke/UGwlZsEeU=
Message-ID: <5d6222a80803060349g69f570f3j9eaab980d7c58da@mail.gmail.com>
Date: Thu, 6 Mar 2008 08:49:06 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/1] export native versions of machine_ops functions
Cc: "Glauber Costa" <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20080306105500.GK13391@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204739040-18422-1-git-send-email-gcosta@redhat.com>
	 <20080306105500.GK13391@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 7:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Glauber Costa <gcosta@redhat.com> wrote:
>
>  > People overriding machine_ops provided functions may want to call the
>  > native version after its pre-processing. It already happens for the
>  > smp_ops functions, so I don't see a reason for avoiding it here.
>
>  i'd like to do this only if there are actual users - otherwise we'll get
>  a trickle of "make needlessly global functions static" patches a few
>  weeks later ;-)
>
>         Ingo
>

KVM is a user for that. Because it registers a memory area in which
the host will be continually writting to (the clock), when it
shutdown, the host
have no way to know it has to stop. If you're really shutting down,
there's no problem. But if you're kexecing, for example, the host will
keep writting to a random
memory area after the new kernel installs.


-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
