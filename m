Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbZLRR05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbZLRR05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZLRR0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:26:53 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:51868 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbZLRR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:26:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=XDeaqrUouGgR/Qs+hJDYVkforVwGySs+9THCIzM3EyLiYIQ1pImGu6Y48sLuhnJjj/
         Figu63i6IiEqWlbJy39CI18eFvcnh2WGtezUVoGi/xVoENtYqtpOnkI3OWJIsOZVmlmV
         9AgBW+dlvWhHi4M9kG7XpH8BwDmqr/2C0AH1E=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 09:26:29 -0800
Message-ID: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com>
Subject: git pull on linux-next makes my system crawl to its knees and beg for 
	mercy
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't describe it any better. It really is pissing me the fuck off,
its as if I have invisible elves using my nuts as punching bags.
Something is seriously fucked with 2.6.32, my box, or linux-next, or
perhaps there is another possibility someone might be able to help
enlighten me about which I am not considering.  I'd also would love to
hear from others and see if I'm not the only one because if this issue
is reproducible, it would be bad. First let me describe the issue in
detail.

I tend to always be on a 2.6.32 kernel + John's queued up patches for
wireless for the next kernel release (I use wireless-testing). My
system is a Thinkpad T61, userspace is Ubuntu 9.10 based (ships with
git 1.6.3.3) and I kept an ext3 filesystem to be able to go back in
time to 2.6.27 at will without issues.  I git clone'd linux-next a few
weeks ago. After a few days I then tried to git pull and my system
became completely unusable, It took *ages* to open up a terminal and
start running commands. Even ssh'ing into my box became a hassle to
the point that my *entire* morning was spent trying to patiently wait
for the git pull to finish. I gave up, I don't recall I had anything
on my kernel logs. Bewildered with this issue I set out to prove to
myself this issue was not a 2.6.32 issue and booted other kernels,
including Ubuntu's distro kernel on 2.6.31 and then later my own built
fresh 2.6.27.41 kernel. The issue was reproducible on all three
kernels!

This lead me to believe this was a system / hard drive issue and
embraced myself for a system fix. I yet needed to prove this was
indeed a system issue. I've been using myself without touching
linux-next for a while now and it works flawlessly, and even doing
testing with ath5k / ath9k for some random projects I have. I git pull
wireless-testing just fine, and pm-suspend just fine every day without
any hiccup.

I then started to suspect I probably got a fucked linux-next somehow,
I do recall I did pm-suspend during a pull of wireless-testing before
and never had issues after resume or with the tree at all. I don't
recall doing the pm-suspend with linux-next but it could be possible.
Since my last giving up on the 'git pull' of linux-next I tried to
'git reset --hard origin' and then trying a 'git pull' but saw my
issue easily becoming unusable again, I ctrl-c'd out of that quickly,
tried 'git fsck' and did fine some complaints. I started to want to
blame my hard drive so I rm -rf'd linux-next and tried a fresh clone.
It pulled fine, my system was slow but nothing *that* unusual.

A couple of days ago I do a 'git pull' again and ... my system starts
crying again, begging me to stop, so I did. My 'git describe' now
tells me I'm at next-20091211 and 'git fsck' tells me:

dangling tree 3500a4301d572e57c700d18d6730f4ac3e33b923
dangling tree e50022fd1e44c3ca63d57e5b263a8263fa5e291b
dangling tree c105e67e2b609e02eefe2b676e53f79b3e375a32
dangling tree 850b60a21ebf9721d16eeb7d68d6e6250893b558
dangling tree dd0bc64a4fe9eac9de3edb0db68d7a83d0477655
dangling tree ac135ee3b2031dcbed733af87c1b82833c1bd035
dangling tree 635a4c8728714746bc1a80692bd7b998af36c7fd
dangling tree 08708a50cd385efc23cfda7dd88cacf951db2237
dangling tree d27198a37d7b393ed9f5dc99c2f56e1c715c4572
dangling tree cc753417b1a3c1b61c0f1b37e7560be1f5404b93
dangling tree 237dcc5120bfe3aebcd2e19ab3640fbecb855ff2
dangling tree 32815626af9eb48dbe04fa790b154a9424871041
dangling tree 299294383dc096b0363ae3f7a49fe937a5e6027c
dangling tree 18acf23ea04f77d96c5eb092bbed0d598eb580ef
dangling tree 08c9e248624d407404e04481adf27d385c3a7e57
dangling tree beccf2344a596fed67cbe0f874210a98bd2b7c40
dangling tree d8df306d4dcf551d47f7d914bd7754c000e541f8
dangling tree 93e83c3ea3a1fef405546af4d99ecd1032ab9b09
dangling tree 65f9e4a9c3af938337fb7ec49eb354ebb19553f5
dangling tree 0a0c81ebe4e60b5941adf92494c45a9cc4ebbd85
dangling tree 5e1b8d853b32c4ee11cf4ef142be4d9a3096f679
dangling tree e11b176056fb40d5ef9cae77af37f53d7bf9342d
dangling tree 8a1e91d681554cafc74586c7ac3eb77299fbb091
dangling tree 10201bc2b2ceac311424bdbc3949a726926a6a3d
dangling tree fa21357016b62184d347f16f22fce54a0fc3aef5
dangling tree e33177806b80d35b0547a76e5fe26b59c55b5aa1
dangling tree cf3a11b7f1b83c86870881cb40f7c1af5b1daf9a
dangling tree e43d57bb730a492b73f6e6a8e5fd218d14e4b741
dangling tree 9f62ff527891032a5f0511f8f38cfe686b15ee5f
dangling tree 7476a37bdcedc8ecc568d73225a55b59899e70df
dangling tree 6085f588e0656a48e76f5e87dfb5ca03e7649bc4
dangling tree ea93955aa22995d17cc90f300343a535c8bdbf0c
dangling tree 1d95edfaf4d9065bf86cae97629fa28dd76e9fd3
dangling tree f29a99c8fee39c9934cca06a00e7ca5b48437ca0
dangling tree ff9bcf59a9392f7856a13c7541107165d8eb5659
dangling tree 3d9e29ac71b065829550996559094525e6f4ea4e
dangling tree cea7adf5352ce365f580066d1e2123e63b48f261
dangling tree 2fa8f7cd3a02839cf41ae7b01267047ffdbcfbe5
dangling tree 42ddc9e3585548880386d48dd7393d4111347ccd
dangling tree 83e30d38fb1e8ca59440f830f9bc203c615eff49
dangling tree 71e83d06ef0bb5bb105cf64bbb80bc6580bc06eb
dangling tree 7bedcf303aafcdedd6d0b3119bd8040d1fab3983
dangling tree 83f1a1eae41b9d6c7d2b6d549c35485a4e20847a
dangling tree eff8c7a202e29a8793b581b4c1b8d372a5289356
dangling tree 84f9bb0e7549269370c88a0878655fa4f5c09b27
dangling tree 4ffa81c9721df067d741fbd40227163d77ff7513

I'm starting to doubt this is a hard drive issue, I will be cloning
linux-next as-is exactly on my system on some other T61 (but a little
bigger and with Nvidia graphics) I have by git clone'ing over ssh to
my linux-next/.git/ and then I'll scp over my linux-next/.git/config
to it and try a git pull and see if that system also goes ape shit.

I am wondering if others have experiences issues like this as well.

Here's my kernel config for wireless-testing:

http://bombadil.infradead.org/~mcgrof/configs/2009/12/wireless-testing.config

And my config for 2.6.27:

http://bombadil.infradead.org/~mcgrof/configs/2009/12/2.6.27.41.config

Even if a git tree gets terribly messed up the issues I'm seeing seem
to painful for an average user to experience, there has got to be
something major going on under the hood, and not sure why I don't see
this sort of thing with following wireless-testing.

  Luis
