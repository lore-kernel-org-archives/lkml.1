Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYJAVPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYJAVPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYJAVPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:15:30 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53310 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYJAVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:15:29 -0400
Date: Wed, 1 Oct 2008 16:15:07 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Valdis.Kletnieks@vt.edu, Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
Message-ID: <20081001211507.GA28377@us.ibm.com>
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp> <20080925165954.GA25587@us.ibm.com> <48DC7553.8040708@nttdata.co.jp> <20080926130409.GA14055@us.ibm.com> <48E053DB.3010201@nttdata.co.jp> <20080930154553.GA29249@us.ibm.com> <48E2E17C.3040108@schaufler-ca.com> <62704.1222837526@turing-police.cc.vt.edu> <48E33397.1030709@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E33397.1030709@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 30 Sep 2008 19:33:32 PDT, Casey Schaufler said:
> >> I have always believed that MAC should come first, then DAC, because
> >> MAC may care if you can see the mode bits. The current DAC before MAC
> >> is an artifact of the desire for the LSM to behave cleanly as a
> >> strictly additional mechanism. From an ideal security perspective
> >> MAC should be first, but the pragmatic DAC first isn't going to cause
> >> too much grief. If Tomoyo wants to do what I think is the right thing,
> >> well, it's OK with me.
> > I'm OK with the MAC going first as well
> Current implementation is as follows.
> - security_path_*: MAC before DAC
> - security_inode_*: DAC before MAC
> I can understand Casey and Valdis' MAC first approach from the ideal 
> security perspective. However, from the pragmatic perspective, we 
> prefer DAC before MAC approach as SELinux does. This approach doesn't 
> change error code returned to callers if requested access is denied 
> by DAC.
> 
> Regards,

I suppose you could do something like define both _path and _inode,
save away your result from the _path hook but always return 0, there,
then if you'd saved off an error and you make it to the _inode hook,
return the error there...

-serge
